class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.110.tar.gz"
  sha256 "6056401e917302f2b87bb30ad416f02977e6e4a566a86c8e926d66d4c1f01101"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "abeac996070b6dc0f85abfd6958693a994173955875c2348ca4442f0c4096bfe" => :sierra
    sha256 "aaaaec9aff97ef0a9ae692b7945a30ed817203b076225e0aff31d07f2e287f93" => :el_capitan
    sha256 "7508f7959901b86674cb795c8b38f3f673421f9f7c16a2d2dde9545dadcadf8b" => :yosemite
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
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
