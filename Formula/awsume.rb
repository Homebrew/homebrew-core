class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.3.0.tar.gz"
  sha256 "71323eb04bfbbf61aa22f0f4c947329be3883e8111452cc91b4dbe1b481518c6"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any
    sha256 "e37953394517c3ad482fa7236e1543f0656c8ce850af30e8079a60b500d372aa" => :catalina
    sha256 "cc9fb242edd68a6503f20b49db02d9bc943d255745c6f2e766891767051173d5" => :mojave
    sha256 "c41a8393be66c50dc1551bcd6c7077648d1cbb0b6955e8a34a8aa48cfe528ee9" => :high_sierra
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
