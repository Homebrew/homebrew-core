class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/c5/6d/f23bcf595dc806f43af43853aa89614e5f30b046365c0639e84777606879/hy-0.26.0.tar.gz"
  sha256 "07d2cd59f2b6ee6207fa94048a27ed45c5db0bae5a3893335cfa7dc74efc97a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "358f2a4bcd2af450a9c31c03b7c3b7b1f6db6f418a986e0e369b104a4cded045"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "991786bb1d03492a126cf05ee8c117a0799048e9bcf95d1b3f9923176ed3fea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2d9fa5bded872112d217cabff691a9f24cdf5deab5aecb9a64ace08d0f82e93"
    sha256 cellar: :any_skip_relocation, ventura:        "2fae5d8f74ff09e7546c245d1f831e2fca91ba0a86734a8f783d9c82485f38a1"
    sha256 cellar: :any_skip_relocation, monterey:       "d66e6e631ad4d79873d47f66d153bf7bc7dfd6030b0e7836981370320af16d2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b67bd5a34d9366292c77f3354befff4c2cb8853b99d8572e71807ab643235a23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41870e64b014870af2ddc4f4a1e2262e152ce33034944b2824a72d9850f990c7"
  end

  depends_on "python@3.11"

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/93/44/a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7/funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    python3 = "python3.11"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{python3} test.py")
  end
end
