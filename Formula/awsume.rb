class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.2.7.tar.gz"
  sha256 "96a7f3fef76aabf459ba5533ec72f5303c59267a0b6cb03f8b6f67415c848a67"
  revision 1
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1697566da97be3e9a067afe9e6af53137d60834244a64dc1fca368a282c53731" => :catalina
    sha256 "8f8363d9ef1a7c932e27f7848d503b06ef7b10c61f890d672ca185f9dfa2886b" => :mojave
    sha256 "670e56b9065f8b080be0b6a59b2632396b85ab59d9a2ef9094aa0501e611fd34" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python@3.8"
  uses_from_macos "sqlite"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "awsume"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_includes "4.0.0", shell_output("#{bin}/awsume -v")

    file_path = File.expand_path("~/.awsume/config.yaml")
    shell_output(File.exist?(file_path))

    assert_match "PROFILE  TYPE  SOURCE  MFA?  REGION  ACCOUNT", shell_output("#{bin}/awsume --list-profiles 2>&1")
  end
end
