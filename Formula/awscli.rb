class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.16.110.tar.gz"
  sha256 "4e14679669b7f7b6a608cccb8d9c688db4a18dddf26ed5c91088e43a8281c568"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "cceb0eabc55e43febff0df429d41e1ee230293abe2c96d543238c91f366fbdfb" => :mojave
    sha256 "117e16237a467e606baccf875b540c5c84c38f1a29dbeda085c356cdfac9bd21" => :high_sierra
    sha256 "7ebef63757191c2d8ecbe08263c81e326086b29e46c8f41200ac48486207ec9c" => :sierra
  end

  # Some AWS APIs require TLS1.2, which system Python doesn't have before High
  # Sierra
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats; <<~EOS
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
  EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
