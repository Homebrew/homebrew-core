class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.160.tar.gz"
  sha256 "42b3036140953b78615456498b5f00fd1b88c6219080249693352408f819f4a3"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "d9c28645504953cd9f74040801d626d53c69e20f84201ab78745b8093e6361f9" => :high_sierra
    sha256 "afb2936f2ae69e67418f4f50dc105b1e10fa6d02fbb03e837daf18db6ab232f0" => :sierra
    sha256 "c3781ac0bc4e0d0f19a2bd7a62144d9892e50a864aacc84a1ec5dcd563d0c602" => :el_capitan
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awscli"
    # Remove Windows file
    inreplace buildpath/"setup.py", "'bin/aws.cmd',", ""
    venv.pip_install_and_link buildpath
    pkgshare.install "awscli/examples"

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
