class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.38.tar.gz"
  sha256 "7f7210efda119a46a0fd1b9abfaf8271d822dbd112afed6e7c2697bc5b6183c0"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "6323d90070d7d7fcdf796473ee3233018b59ff401e983a0813f03214ae212e2e" => :sierra
    sha256 "8fd747e85b26e164c7b6b00f6e2b6c2b224a08b8b5b28a0dd52b96185e06da80" => :el_capitan
    sha256 "4d805194e8ce15153cdd8e45d61aca4a1353767ab6b7285ff5e2f9c8aef687f1" => :yosemite
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

    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh" => "_aws"
  end

  def caveats; <<-EOS.undent
    The "examples" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/awscli/examples

    Before using aws-cli, you need to tell it about your AWS credentials.
    The quickest way to do this is to run:
      aws configure

    More information:
      https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
      https://pypi.python.org/pypi/awscli#getting-started
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
