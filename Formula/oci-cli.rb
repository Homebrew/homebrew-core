class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://github.com/oracle/oci-cli/archive/v2.12.6.tar.gz"
  sha256 "9f2faa7b05adee3b3f6d3da6578091561833e3997f5b97e5126ac3a6f148b574"
  license ["UPL-1.0", "Apache-2.0"]
  head "https://github.com/oracle/oci-cli.git"

  bottle do
    cellar :any
    sha256 "03c1f7e75fde9516514e2d3bc6c4024cf608e945c264bccca106bbc5956e3e00" => :catalina
    sha256 "4a0582a579ef1f4a527d356365bab0c7f17f488e4cf6f72c0b9368f7dcdde9c0" => :mojave
    sha256 "338603b9c7c67885230e33eb3c03be160a615f0fe42247826d99e3264f684fb3" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                                "--ignore-installed", buildpath

    venv.pip_install_and_link buildpath

    bin.install_symlink libexec/"bin/oci"
  end

  test do
    version_out = shell_output("#{bin}/oci --version")
    assert_match version.to_s, version_out

    assert_match "Usage: oci [OPTIONS] COMMAND [ARGS]", shell_output("#{bin}/oci --help")
    assert_match "", shell_output("#{bin}/oci session validate", 1)
  end
end
