class Awscli < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  url "https://github.com/aws/aws-cli/archive/1.11.57.tar.gz"
  sha256 "703c4c355d6d6339811247a8343cd71468cef42494ed6dabafa8b414482f2da9"
  head "https://github.com/aws/aws-cli.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4f283864e452bef2f32b5e3f9a5616274e31ebf04a2036ec4d2152f8e0054a0" => :sierra
    sha256 "92a3ca96073779a92ab756f81ca59ffe469a36d3bf52d02839010efd262ffab2" => :el_capitan
    sha256 "2c3fd38d1a01a9d7018529a21f8d64b9847cd91aae8a36a036c3ce7175813f28" => :yosemite
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
