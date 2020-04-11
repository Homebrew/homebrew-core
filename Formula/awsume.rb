class Awsume < Formula
  include Language::Python::Virtualenv

  desc "Utility for easily assuming AWS IAM roles from the command-line"
  homepage "https://www.trek10.com/blog/awsume-aws-assume-made-awesome"
  url "https://github.com/trek10inc/awsume/archive/4.4.0.tar.gz"
  sha256 "8da85ba5c703136618a0bd9557311bb6717d5b7daab014aebbce888328f299c7"
  head "https://github.com/trek10inc/awsume.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db77dc1971794366c6fb7149ea5a81fdd8a362962e95508c1590d11542ba15bc" => :catalina
    sha256 "40865468a41516ffb9983f8488440fdfa3b31267159b78f15cecab70dff0d97f" => :mojave
    sha256 "1299579a47958e27e1d3cdb4925e8abf346aa048c9a6df4bae8b1abf02fba684" => :high_sierra
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
