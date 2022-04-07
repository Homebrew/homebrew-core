class Nvs < Formula
  desc "Cross-platform tool for switching between versions and forks of Node.js"
  homepage "https://github.com/jasongin/nvs"
  url "https://github.com/jasongin/nvs/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "2259610ffc1700d0dbf4586f76377981b6f73025c1a10775dd2ee04e3cbb6210"
  license "MIT"

  def install
    prefix.install "nvs.sh", "package.json", "defaults.json", "deps", "lib"
  end

  def caveats
    <<~EOS
      Please note that upstream has asked us to make explicit managing
      nvm via Homebrew is unsupported by them and you should check any
      problems against the standard nvm install method prior to reporting.

      Add the following to #{shell_profile} or your desired shell
      configuration file:

        export NVS_HOME="$HOME/.nvs"
        NVS_ROOT=#{opt_prefix}
        [ -s "$NVS_ROOT/nvs.sh" ] && . "$NVS_ROOT/nvs.sh"

      You can set $NVS_HOME to any location, but leaving it unchanged from
      #{prefix} will destroy any nvs-installed Node installations
      upon upgrade/reinstall.

      Type `nvs help` for further information.
    EOS
  end

  test do
    # Install bootstrapping Node.js
    system "NVS_HOME=$(pwd) \. #{prefix}/nvs.sh install"

    # Checking path for a non-existent Node.js version/alias should report errors
    output = pipe_output("NVS_HOME=$(pwd) \. #{prefix}/nvs.sh && nvs which homebrewtest 2>&1")
    refute_match(/No such file or directory/, output)
    refute_match(/nvs: command not found/, output)
    assert_match "Specified version not found.\nTo add this version now: nvs add null", output

    # Adding a non-existent Node.js version should report errors
    output = pipe_output("NVS_HOME=$(pwd) \. #{prefix}/nvs.sh && nvs add homebrewtest 2>&1")
    refute_match(/No such file or directory/, output)
    refute_match(/nvs: command not found/, output)
    assert_match "Version homebrewtest not found in remote: node", output

    # Removing a non-existent Node.js version/alias should report errors
    output = pipe_output("NVS_HOME=$(pwd) \. #{prefix}/nvs.sh && nvs rm homebrewtest 2>&1")
    refute_match(/No such file or directory/, output)
    refute_match(/nvs: command not found/, output)
    assert_match "Specify a semantic version.", output

    # Adding a Node.js version 16.14.2 should succeed
    output = pipe_output("NVS_HOME=$(pwd) \. #{prefix}/nvs.sh && nvs add v16.14.2 2>/dev/null")
    refute_match(/No such file or directory/, output)
    refute_match(/nvs: command not found/, output)
    assert_match "Added at: ~/node/16.14.2", output
  end
end
