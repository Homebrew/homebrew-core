#!/usr/bin/python3.10

import requests
import time

depens = ["autopage", "Babel", "cliff", "cmd2", "debtcollector", "decorator", "dogpile.cache", "importlib-metadata",
          "iso8601", "jsonpatch", "jsonpath-rw", "jsonpath-rw-ext", "jsonpointer", "jsonschema",
          "jsonschema-specifications", "keystoneauth1", "murano-pkg-check", "netaddr",
          "netifaces", "openstacksdk", "os-client-config", "os-service-types", "osc-lib", "oslo.config",
          "oslo.context", "oslo.i18n", "oslo.log", "oslo.serialization", "oslo.utils",
          "prettytable", "pycparser", "pyOpenSSL",
          "pyperclip", "python-barbicanclient", "python-ceilometerclient", "python-cinderclient",
          "python-cloudkittyclient", "python-dateutil", "python-designateclient", "python-fuelclient",
          "python-glanceclient", "python-heatclient", "python-keystoneclient", "python-magnumclient",
          "python-manilaclient", "python-mistralclient", "python-monascaclient", "python-muranoclient",
          "python-neutronclient", "python-novaclient", "python-openstackclient", "python-saharaclient",
          "python-senlinclient", "python-swiftclient", "python-troveclient", "referencing",
          "requests", "requestsexceptions", "rfc3986", "rpds-py", "semantic-version", "simplejson",
          "stevedore", "tzdata", "warlock", "wrapt", "yaql", "zipp"]

# depens = ["os-client-config"]

resourceList = []
for PACKAGE in depens:
    print(PACKAGE)
    package_info_url = f"https://pypi.org/pypi/{PACKAGE}/json"

    # Make a GET request to retrieve JSON data about the package from PyPI
    response = requests.get(package_info_url)
    data = response.json()

    # Extract URL and SHA256 from the fetched data
    releases_data = data["releases"]
    # latest_release_version = max(releases_data.keys())
    latest_release_version = max(releases_data.keys())
    latest_release_files = releases_data[latest_release_version]

    url, sha256_digest = None, None

    try:
        file_info = latest_release_files[0]  # Assuming there is at least one file in each release
    except IndexError:
        latest_release_version = sorted(releases_data.keys(), reverse=True)[1]
        latest_release_files = releases_data[latest_release_version]

    for file_info in latest_release_files:
        if file_info["filename"].endswith(".tar.gz"):
            url = file_info["url"]
            sha256_digest = file_info["digests"]["sha256"]
            break
    # try:
    #     file_info = latest_release_files[0]  # Assuming there is at least one file in each release
    # except IndexError:
    #     latest_release_version = sorted(releases_data.keys(), reverse=True)[1]
    #     # print(latest_release_version)
    #     latest_release_files = releases_data[latest_release_version]
    #     # print(latest_release_files)

    #     file_info = latest_release_files[0]
    #     # print(f"file_info: {file_info}")


    url = file_info["url"]
    sha256_digest = file_info["digests"]["sha256"]

    resourceList.append({PACKAGE: {"url": url, "sha": sha256_digest}})
    time.sleep(1)

with open("output.txt", "w+") as f:
    for i in resourceList:
        for package in i:
            print(package)
            f.write(f"""
        resource "{package}" do
            url "{i[package]["url"]}"
            sha256 "{i[package]["sha"]}"
        end
                    """)
