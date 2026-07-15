*** Settings ***
Documentation     Tests for passing a Robot Framework 7.4 Secret as the ``url``
...               argument of `Open Browser`. The real url must reach Selenium
...               for navigation while the secret value stays out of Robot
...               Framework output and SeleniumLibrary logging.
Suite Teardown    Close All Browsers
Resource          resource.robot

*** Test Cases ***
Open Browser Accepts Secret URL
    [Documentation]    A Secret url is accepted and navigation succeeds.
    [Tags]    require-rf-7.4
    VAR    ${url: Secret}    %{SELENIUMLIBRARY_SECRET_URL_FRONT_PAGE=${FRONT PAGE}}
    Open Browser    ${url}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    Location Should Be    ${FRONT PAGE}
    [Teardown]    Close All Browsers

Open Browser Does Not Log Secret URL
    [Documentation]    Passing a Secret url must not expose the real url in Robot
    ...    Framework output. SeleniumLibrary logs the masked Secret and suppresses
    ...    Selenium's own logging while the url is passed to Selenium. To verify
    ...    the real value never leaks, run this suite with the environment variable
    ...    SELENIUMLIBRARY_SECRET_URL set to a url containing a unique token and
    ...    confirm the token is absent from output.xml.
    ...    LOG 2:1    INFO    GLOB: Opening browser '*' to base url '<secret>'.
    [Tags]    require-rf-7.4    NoGrid
    VAR    ${url: Secret}    %{SELENIUMLIBRARY_SECRET_URL=${FRONT PAGE}}
    Open Browser    ${url}    ${BROWSER}    remote_url=${REMOTE_URL}
    ...    desired_capabilities=${DESIRED_CAPABILITIES}
    [Teardown]    Close All Browsers
