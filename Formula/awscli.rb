class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.115.tar.gz"
  sha256 "a50016f5e688c28e719f2d6dc4e9f1066d3be39e71255215dbaa05d3e7a3ce08"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "76e857f5cbb4c5a4303a2ead3ec16e3f84eb2e912073f33d4edc85550d8fec4b" => :sierra
    sha256 "68ec7a6947790ac8cd1255e7c5291fcf32c5418a9f6b4f53faa5c46a4d6d3eaa" => :el_capitan
    sha256 "8e9d99ea146904707ab5a1030e6fc98924ef1b0f0fd11b8bb41b4620492b57de" => :yosemite
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
