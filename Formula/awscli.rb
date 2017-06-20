class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.108.tar.gz"
  sha256 "d1d2f546213ccd5ce71644d817f4c6202cf289926dbf4c6ab9dd840fa4d56a12"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4d4fcf1b442c433b0176d0718a59c3e1a2edb9b38a11b4b1fc5a94b043765a5" => :sierra
    sha256 "ed4c9771e26cca658cdafea82ce8f361980d7c56b67e8cb88fc2f4cc74702b6b" => :el_capitan
    sha256 "82f4634d23e2530efec50c7cfdfd9dac2356703c319fc30ac0b9be717f2c7012" => :yosemite
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
