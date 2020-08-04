class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://github.com/oracle/oci-cli/archive/v2.12.5.tar.gz"
  sha256 "bb824a8b2700ec3df6180ae00aaa444485b64eb60d8d8fcb03993f9bd449ccd9"
  license "UPL-1.0"
  # https://github.com/Homebrew/homebrew-core/pull/57974 license: "UPL-1.0", "Apache-2.0"
  head "https://github.com/oracle/oci-cli.git"

  bottle do
    cellar :any
    sha256 "fd63fa7a8d033fa15d6454496e195ef9416e237a300a0c826ae04f69d755cde2" => :catalina
    sha256 "55f626b265bcb6640100d7e7473f9f1beb6136f9b1599a41ebb7f8324c8ecdf7" => :mojave
    sha256 "07004b18fa035013a194a648ff71a40c9a390c08f772e6bf2994a78745012c60" => :high_sierra
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
