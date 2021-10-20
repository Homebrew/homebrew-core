class Doc8 < Formula
  include Language::Python::Virtualenv

  desc "Style checker for Sphinx documentation"
  homepage "https://github.com/PyCQA/doc8"
  url "https://files.pythonhosted.org/packages/bb/fd/a39b9b8ce02f38777a24ce06d886b1dd23cea46f14b0f0c0418a03e5254d/doc8-0.9.1.tar.gz"
  sha256 "0e967db31ea10699667dd07790f98cf9d612ee6864df162c64e4954a8e30f90d"
  license "Apache-2.0"
  revision 1
  head "https://github.com/PyCQA/doc8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef9dd2c5a52fffc7d9daf8a5308bc48eb87b21b350bc4508e62d7785955b3b66"
    sha256 cellar: :any_skip_relocation, big_sur:       "ea5c82933dfaec4a02061ab64bb164cfe83f31deaccdadbb3d0462923e980cea"
    sha256 cellar: :any_skip_relocation, catalina:      "ea5c82933dfaec4a02061ab64bb164cfe83f31deaccdadbb3d0462923e980cea"
    sha256 cellar: :any_skip_relocation, mojave:        "ea5c82933dfaec4a02061ab64bb164cfe83f31deaccdadbb3d0462923e980cea"
  end

  depends_on "python@3.10"

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4c/17/559b4d020f4b46e0287a2eddf2d8ebf76318fd3bd495f1625414b052fdc9/docutils-0.17.1.tar.gz"
    sha256 "686577d2e4c32380bb50cbb22f575ed742d58168cee37e99117a854bcd88f125"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "restructuredtext-lint" do
    url "https://files.pythonhosted.org/packages/45/69/5e43d0e8c2ca903aaa2def7f755b97a3aedc5793630abbd004f2afc3b295/restructuredtext_lint-1.3.2.tar.gz"
    sha256 "d3b10a1fe2ecac537e51ae6d151b223b78de9fafdd50e5eb6b08c243df173c80"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f9/57/328653fd8a631d81b2d71261e471a102d5b64a95c1b1dda1a55b053bf0db/stevedore-3.4.0.tar.gz"
    sha256 "59b58edb7f57b11897f150475e7bc0c39c5381f0b8e3fa9f5c20ce6c89ec4aa1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.rst").write <<~EOS
      Heading
      ------
    EOS
    output = pipe_output("#{bin}/doc8 broken.rst 2>&1")
    assert_match "D000 Title underline too short.", output
  end
end
