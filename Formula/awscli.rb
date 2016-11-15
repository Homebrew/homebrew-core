class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.15.tar.gz"
  sha256 "0ab27d7f35e3a9d90d9d43141a014bfee461a472a37dad02682cdef6ef08a0be"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4bc9c2d202274faaa7a73ad2ce69b7301618ae57b9cde10c444794639624aa4" => :sierra
    sha256 "1a44a79be03d2178f379914e591528bbe9e1e38a42cd82a437854095e8e8bd78" => :el_capitan
    sha256 "1654f15985199176cd36d7f8ba28e13bf47c463f8b38899ab28be4a75293f14d" => :yosemite
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
