class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.2.6.tar.gz"
  sha256 "2a23b4ae830b75d228019b6f4e8e1c3bfdc8a96c5aff9f000643b3571fd37c7f"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e546d05461520e832262204e93dccc9f83971a0895b763ac6bd41565ad585e3" => :catalina
    sha256 "57e9f8aca66bceed78bbca813f8f192e28f4f2156c4fbbb743a7041e27b4a404" => :mojave
    sha256 "b952b396daaf2b3ffc0a757debfa9443413c3bf00a5902259e0363935a25d202" => :high_sierra
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
