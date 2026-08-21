class Badread < Formula
  include Language::Python::Virtualenv

  desc "Long read simulator that can imitate many types of read problems"
  homepage "https://github.com/rrwick/Badread"
  url "https://github.com/rrwick/Badread/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "488ee2c4b87c064904e2ea1ef24ef833c2f5932aa4c1f03e361e2e4061692baf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "042371e9220506883e1d344f62ab2c7a2beca38c5d4359219893ba9a517e1a20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c8e760d6d86ae2238545fe656ac46d5f1ebae4529f6d0eda0a110a0b513d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7ca617c2e12300fba81a3b52bd31805766c17fbd9de2ec40a948353092b3b4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e88eedc375f0f23edb10028f857b875ff32a69e558ee8c5bfd05b6c2e27366df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2b062e71fcedb714e622bdf5305cb2fdb8c8ad63e78f774255d0f0694e5bf9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d717a9b91d6b2dd37f3bcdb945a7446a0bdc5726725dc0fbe589e19e5b410d"
  end

  depends_on "numpy"
  depends_on "python@3.14"
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
