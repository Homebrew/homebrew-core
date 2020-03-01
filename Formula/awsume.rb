class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.2.6.tar.gz"
  sha256 "2a23b4ae830b75d228019b6f4e8e1c3bfdc8a96c5aff9f000643b3571fd37c7f"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b0dba57fd46e839c5c1a06e61845e9540b5bfeb731e7cead4e1690f0b5fff1b" => :catalina
    sha256 "44ba1d3057fd94aa715e2ccae140088bf382fa1e1b0cb519baf9621fd1f54902" => :mojave
    sha256 "4799a2384a87f2c15ea5eec27a24887a55063d0c859d616c06fd2990f21e6bbb" => :high_sierra
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
