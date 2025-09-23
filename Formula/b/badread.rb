class Badread < Formula
  include Language::Python::Virtualenv

  desc "Long read simulator that can imitate many types of read problems"
  homepage "https://github.com/rrwick/Badread"
  url "https://github.com/rrwick/Badread/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "236dee5ac99b8d0c1997c482df5b805908b0c34f75277ef706e897af71db1f9a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5bdbf37f5234814869e8dfe4a03fea167c8fee0d8e0b35c95eaf3f533a6028e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5938c3cea8d94f65b2a7b6c72766f127c81c9a6b0fc96fe5ed2f8d820898d5b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c297b72a55ad77e5d55265960b8c18eac6558cab393c00d35585201317df19ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b40ec3e8905345b20c7c70f723dddb18217421511fe188ab0fbf3b665b60f46a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f6c2d20d2f85961db238a4bea9316fb46153c354d71b77b4325baf7105c97f0"
    sha256 cellar: :any_skip_relocation, ventura:       "19885698a620d42a588f5e91421e978f470b016587cc7e907de3867bf0e891c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8196a5a5cd8ac1211b0413d6ace9c8c82ec2467d737ec8224438d0098ec91aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7486cdbdd9b1c62830833a9dbef4abc4c25594860367bfd52f97266fdd867e2c"
  end

  depends_on "numpy"
  depends_on "python@3.13"
  depends_on "scipy"

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
