class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/nvm-sh/nvm"
  url "https://github.com/creationix/nvm/archive/v0.38.0.tar.gz"
  sha256 "35bb7bc74bf9efacde270ee5f52ef3c41fd585c5f8ddd57ca6e8e07e4f29fc74"
  license "MIT"
  head "https://github.com/nvm-sh/nvm.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f3cd481b024f9e46a56450d6aaf43c83875e8e7796db6838a6441195b039a368"
  end

  def install
    prefix.install "nvm.sh", "nvm-exec"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats
    <<~EOS
      Please note that upstream has asked us to make explicit managing
      nvm via Homebrew is unsupported by them and you should check any
      problems against the standard nvm install method prior to reporting.

      You should create NVM's working directory if it doesn't exist:

        mkdir ~/.nvm

      Add the following to #{shell_profile} or your desired shell
      configuration file:

        export NVM_DIR="$HOME/.nvm"
        [ -s "#{opt_prefix}/nvm.sh" ] && \. "#{opt_prefix}/nvm.sh"  # This loads nvm
        [ -s "#{opt_prefix}/etc/bash_completion.d/nvm" ] && \. "#{opt_prefix}/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

      You can set $NVM_DIR to any location, but leaving it unchanged from
      #{prefix} will destroy any nvm-installed Node installations
      upon upgrade/reinstall.

      Type `nvm help` for further information.
    EOS
  end

  test do
    output = pipe_output("NODE_VERSION=homebrewtest #{prefix}/nvm-exec 2>&1")
    refute_match(/No such file or directory/, output)
    refute_match(/nvm: command not found/, output)
    assert_match "N/A: version \"homebrewtest -> N/A\" is not yet installed", output
  end
end
