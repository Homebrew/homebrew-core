class OciCli < Formula
  include Language::Python::Virtualenv

  desc "Oracle Cloud Infrastructure CLI"
  homepage "https://docs.cloud.oracle.com/iaas/Content/API/Concepts/cliconcepts.htm"
  url "https://github.com/oracle/oci-cli/archive/v2.12.4.tar.gz"
  sha256 "de0c0b476b691a5582d1e282a1ca60916d3f968636d346bcb7848f427c5fae66"
  license "UPL-1.0"
  # https://github.com/Homebrew/homebrew-core/pull/57974 license: "UPL-1.0", "Apache-2.0"
  head "https://github.com/oracle/oci-cli.git"

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
