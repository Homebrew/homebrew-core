class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.11.tar.gz"
  sha256 "dfc1876ba94cd507f38e2eccdfe4053c0450d0dd02d19a353dbd1499fd508eae"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "615eb627b5a906ab90517e61e8db1eeb0c9510c6bbd590931bac54561f7159d4" => :sierra
    sha256 "af789fdbf0ccd9175955dbce9c1feb0f58f04cdc851711c0397a2dc2e03d9c18" => :el_capitan
    sha256 "8ad8dbf983c3fa329ab0150b38bb27bbc86d443a4d7ee282bb3fbc1f4d1449ca" => :yosemite
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
