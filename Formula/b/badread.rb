class Badread < Formula
  include Language::Python::Virtualenv

  desc "Long read simulator that can imitate many types of read problems"
  homepage "https://github.com/rrwick/Badread"
  url "https://github.com/rrwick/Badread/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "488ee2c4b87c064904e2ea1ef24ef833c2f5932aa4c1f03e361e2e4061692baf"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7cdb0f92903f07557ac3a79fdaf9d4217c1bb7f763f48e769a4a7a0d54914dd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e2bb8d984f5980457f37533b08732fc31f63a65b909c09eea43ff2fb518402ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "512e9b1c4cab516ccdb1771482c57ae3f9c9204e126c818984cda1d15d0ef5cd"
    sha256 cellar: :any,                 arm64_linux:       "0f545a3c8ea2aa4f5c5abd37cc5acb4bf7ad11e941448a9866002ea5a64cd273"
    sha256 cellar: :any,                 x86_64_linux:      "e8ddd468f896d5b1620a3be1c5212fe60ddb28df631cc105196ffcfcad4a5e30"
  end

  depends_on "numpy"
  depends_on "python@3.15"
  depends_on "scipy" => :no_linkage

  pypi_packages exclude_packages: ["numpy", "scipy"]

  resource "edlib" do
    url "https://files.pythonhosted.org/packages/0c/dd/caa71ef15b46375e01581812e52ec8e3f4da0686f370e8b9179eb5f748fb/edlib-1.3.9.post1.tar.gz"
    sha256 "b0fb6e85882cab02208ccd6daa46f80cb9ff1d05764e91bf22920a01d7a6fbfa"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/test_ref_2.fasta", testpath
    output = shell_output("#{bin}/badread simulate --reference test_ref_2.fasta --quantity 1x")
    assert_match "error-free_length", output
  end
end
