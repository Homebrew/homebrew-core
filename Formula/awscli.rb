class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.12.tar.gz"
  sha256 "75404d9977618a90d1d9d41ad6de58263ec151b5798454b14e15674d9c29e994"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a8a504c859c601f36b692d221837c72da9514f68e1476374613161296805b0a" => :sierra
    sha256 "3794e3efb4b3caaf7ccab3f220763a7f36b0d0690235e6db378e561079f81428" => :el_capitan
    sha256 "3bd07c676d619a5827abd0b8c313f527966cdac3faf7f8bb915e87e6c8aad74d" => :yosemite
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
