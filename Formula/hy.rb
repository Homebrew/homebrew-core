class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/fc/d1/95dac7cb3e3a483cf53a8c18f529f50c619e6a4ee42b299802ca769dc174/hy-0.25.0.tar.gz"
  sha256 "50ed88834b03a33fc25b85d8897bbe15b7846b84d324630ace8d052f7d48327b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7df14b72e77baf89aa3deb363b57e23f37dafa5dcbf2ff5fba5a8b9c9858ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e15ed91dc5c45758d18a02bf06cc2765714ae2f54cfb683a1c9d5fc3e36fe086"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5f9f99c934ff6947f9037b65ebc32579005c265fb3be5c976087e5bcafa4531"
    sha256 cellar: :any_skip_relocation, monterey:       "deda1c0fbdac60c70a30b9dada539dd8b92c2daf0a05e2fd9c24e255bab2115e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b96dd8de1b784c10c4c3545f9890fb44bbf5fab5f1843abae67cd5ad0210e91c"
    sha256 cellar: :any_skip_relocation, catalina:       "0f0b54ba6b6e93b0b884c22148f8c269d9bfdf1707817b7f5558cc2988581386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e03489269cbb7c289c7bf00dc324e01cccdcb72b1c53788feafea3fde0fb77"
  end

  depends_on "python@3.11"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

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
