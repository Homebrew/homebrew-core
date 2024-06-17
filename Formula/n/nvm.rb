class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/nvm-sh/nvm"
  url "https://github.com/nvm-sh/nvm/archive/refs/tags/v0.39.7.tar.gz"
  sha256 "dc514465f99541304380f06b602d6e2a8f3f63584f7321d76f39a10c279c5ed7"
  license "MIT"
  head "https://github.com/nvm-sh/nvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fafb27126e5f79d1b2cd4f92a47a1ef186b020be0217fd8cc79d5d12d4e64d49"
  end

  def install
    (prefix/"nvm.sh").write <<~EOS
      # $NVM_DIR should be "$HOME/.nvm" by default to avoid user-installed nodes destroyed every update
      [ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
      \\. #{libexec}/nvm.sh
      # "nvm exec" and certain 3rd party scripts expect "nvm.sh" and "nvm-exec" to exist under $NVM_DIR
      [ -e "$NVM_DIR" ] || mkdir -p "$NVM_DIR"
      [ -e "$NVM_DIR/nvm.sh" ] || ln -s #{opt_libexec}/nvm.sh "$NVM_DIR/nvm.sh"
      [ -e "$NVM_DIR/nvm-exec" ] || ln -s #{opt_libexec}/nvm-exec "$NVM_DIR/nvm-exec"
    EOS
    libexec.install "nvm.sh", "nvm-exec"
    prefix.install_symlink libexec/"nvm-exec"
    bash_completion.install "bash_completion" => "nvm"
  end

  def caveats
    <<~EOS
      Please note that upstream has asked us to make explicit managing
      nvm via Homebrew is unsupported by them and you should check any
      problems against the standard nvm install method prior to reporting.

      You should create NVM's working directory if it doesn't exist:
        mkdir ~/.nvm

      Add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export NVM_DIR="$HOME/.nvm"
        [ -s "#{opt_prefix}/nvm.sh" ] && \\. "#{opt_prefix}/nvm.sh"  # This loads nvm
        [ -s "#{opt_prefix}/etc/bash_completion.d/nvm" ] && \\. "#{opt_prefix}/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
    assert_match "N/A: version \"homebrewtest\" is not yet installed", output
  end
end
