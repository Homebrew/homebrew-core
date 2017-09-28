class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.160.tar.gz"
  sha256 "42b3036140953b78615456498b5f00fd1b88c6219080249693352408f819f4a3"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "afe7e20189473c901c4b0ca69d7bac8e654ddbe723947827353fc19f8ed16e46" => :high_sierra
    sha256 "2766c45a690e0efee701816f9287a2c479f98e2bbbd00202fe26c6ee6f75e312" => :sierra
    sha256 "d586e05ee5f97967675f4118956b04a1524382307fb8f2ea6e844a9da173209f" => :el_capitan
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<-EOS.undent
        #compdef aws
        _aws () {
          local e
          e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
          if [[ -f $e ]]; then source $e; fi
        }
    EOS
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
