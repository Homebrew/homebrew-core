class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.1.10.tar.gz"
  sha256 "962b4f7ce25c4647fdc5c286a78cc8a1bf65d75e799116084b4b362a63ef7eb2"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eaa4cc337c25e3f23432f12385f4635e4fe3d62ff42b7b6f7fbc4a15fcb555f1" => :catalina
    sha256 "1b4fa7a372173433d6354595a8247eca0b9f4992737c597a648f7e4d016ab213" => :mojave
    sha256 "436ee2e517851f7ad0c02356a75171106f560484f7d4e05b97a196cf01d2c568" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python"
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
