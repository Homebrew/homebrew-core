class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.4.1.tar.gz"
  sha256 "66d698b4716a1dc7c927778a8fe124a6ac2d99334aff2be5dac6b13598b4e08f"
  head "https://github.com/trek10inc/awsume.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "10a7525ee5a63f2c2f749183e9ce7149c7191e0d5a73818643e6a6f7fbd0ed6d" => :catalina
    sha256 "def0ed36226dac045def2c385d1c46c5afaf631c40e9239699f7c5a3bdf3bf7d" => :mojave
    sha256 "287a877bad427382131f05a11bee3b49a188f3eab1c393838fc7d5a4c0b4d196" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "python@3.8"
  uses_from_macos "sqlite"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
