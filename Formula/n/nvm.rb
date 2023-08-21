class Nvm < Formula
  desc "Manage multiple Node.js versions"
  homepage "https://github.com/nvm-sh/nvm"
  url "https://github.com/nvm-sh/nvm/archive/v0.39.4.tar.gz"
  sha256 "d5929f9f96b6c1546867f4964bcb1799f3d0a61f5a35a7c8ccb87b36fd8f0eb1"
  license "MIT"
  head "https://github.com/nvm-sh/nvm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, ventura:        "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, monterey:       "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca010bc660158fc3f27668146d1c32a9a5054a27823b6beb2dfe7af4a56a8d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bce7a3f249619df50c1ab12a5a5d19487926380365ffe0571e659cd9389c3ff1"
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
