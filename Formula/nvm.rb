class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/nvm-sh/nvm"
  url "https://github.com/creationix/nvm/archive/v0.39.0.tar.gz"
  sha256 "1a3cf49095b36a313a82719a39ca63ed9097934504f29781b2c32decbdb6fec4"
  license "MIT"
  head "https://github.com/nvm-sh/nvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0c15f715d32469ef94e2f6927c32b1e753da63d78231e025924adb389b7cc460"
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
