class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.0.tar.gz"
  sha256 "a50d005447fa8db2a2d90e5b84c27396134206ec14f6606ea0d8f1c1694540bf"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "36507045a76d5d5757ea5a0c2e2da178cd6096f5fd38d3d71a0219b39564ca98" => :sierra
    sha256 "85d8c1afc7736301f647b48632de2ddf3dc07194be17193eb21ab4cec542eecb" => :el_capitan
    sha256 "c9806f56bb3628e02f614638d9c7b0c1bff9e22b83d00e73331ef170683c8f75" => :yosemite
  end

  # Use :python on Lion to avoid urllib3 warning
  # https://github.com/Homebrew/homebrew/pull/37240
  depends_on :python if MacOS.version <= :lion

  def install
    virtualenv_create(libexec)
    bin_before = Dir[libexec/"bin/*"].to_set
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    bin_after = Dir[libexec/"bin/*"].to_set
    bin_to_link = (bin_after - bin_before).to_a
    bin.install_symlink(bin_to_link)

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
