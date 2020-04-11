class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.4.1.tar.gz"
  sha256 "66d698b4716a1dc7c927778a8fe124a6ac2d99334aff2be5dac6b13598b4e08f"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc17cb4862dfdba3d8067105c5fa5e7061a3aee498b8fc68608b667a344886a3" => :catalina
    sha256 "c0f155edb5ca30b4fbded27d2c9c91b5e9e90fe6930ac98c51ed7c5d75052314" => :mojave
    sha256 "bd0129dd80a1662e3459927ecd0a3765457da425bc75b6940ceb9025f491910c" => :high_sierra
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
