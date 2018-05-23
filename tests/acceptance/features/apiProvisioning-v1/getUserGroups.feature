@api
Feature: get user groups
As an admin
I want to be able to get groups
So that I can manage group membership

	Background:
		Given using API version "1"

	Scenario: admin gets groups of an user
		Given user "brand-new-user" has been created
		And group "unused-group" has been created
		And group "new-group" has been created
		And group "0" has been created
		And group "Admin & Finance (NP)" has been created
		And group "admin:Pokhara@Nepal" has been created
		And group "नेपाली" has been created
		And group "Mgmt/Sydney" has been created
		And group "var/../etc" has been created
		And group "priv/subadmins/1" has been created
		And user "brand-new-user" has been added to group "new-group"
		And user "brand-new-user" has been added to group "0"
		And user "brand-new-user" has been added to group "Admin & Finance (NP)"
		And user "brand-new-user" has been added to group "admin:Pokhara@Nepal"
		And user "brand-new-user" has been added to group "नेपाली"
		And user "brand-new-user" has been added to group "Mgmt/Sydney"
		And user "brand-new-user" has been added to group "var/../etc"
		And user "brand-new-user" has been added to group "priv/subadmins/1"
		When user "admin" sends HTTP method "GET" to API endpoint "/cloud/users/brand-new-user/groups"
		Then the groups returned by the API should be
			| new-group            |
			| 0                    |
			| Admin & Finance (NP) |
			| admin:Pokhara@Nepal  |
			| नेपाली               |
			| Mgmt/Sydney          |
			| var/../etc           |
			| priv/subadmins/1     |
		And the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: subadmin tries to get other groups of the user in his group
		Given user "newuser" has been created
		And user "subadmin" has been created
		And group "newgroup" has been created
		And group "anothergroup" has been created
		And user "subadmin" has been made a subadmin of group "newgroup"
		And user "newuser" has been added to group "newgroup"
		And user "newuser" has been added to group "anothergroup"
		When user "subadmin" sends HTTP method "GET" to API endpoint "/cloud/users/newuser/groups"
		Then the groups returned by the API should include "newgroup"
		And the groups returned by the API should not include "anothergroup"
		And the OCS status code should be "100"
		And the HTTP status code should be "200"

	Scenario: normal user tries to get the groups of another user
		Given user "newuser" has been created
		And user "anotheruser" has been created
		And group "newgroup" has been created
		And user "newuser" has been added to group "newgroup"
		When user "anotheruser" sends HTTP method "GET" to API endpoint "/cloud/users/newuser/groups"
		Then the OCS status code should be "997"
		And the HTTP status code should be "401"
		And the API should not return any data

	Scenario: admin gets groups of an user who is not in any groups
		Given user "brand-new-user" has been created
		And group "unused-group" has been created
		When user "admin" sends HTTP method "GET" to API endpoint "/cloud/users/brand-new-user/groups"
		Then the OCS status code should be "100"
		And the HTTP status code should be "200"
		And the list of groups returned by the API should be empty
