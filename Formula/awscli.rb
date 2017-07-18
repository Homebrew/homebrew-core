class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.160.tar.gz"
  sha256 "42b3036140953b78615456498b5f00fd1b88c6219080249693352408f819f4a3"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f4d2c2708e500081cdd01638f79aadfbe7519f23bebcadece27868db9f606f65" => :high_sierra
    sha256 "f3ee683be62b7dfd6a2aca88172c543363afa7d8c47b78f552cfcf11870b895d" => :sierra
    sha256 "cbf133991d3ab0f459620df004a11324d3157f9241c221a4b4c11c26ca01b6d5" => :el_capitan
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
