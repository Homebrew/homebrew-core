class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/96/18/ded2cebddf51e424fa31ea4ec31679a793d41e474242e9692ffafdaf84ad/hy-1.3.0.tar.gz"
  sha256 "4af4bd7b262ba0f41bc2d441219ddb455036c0e8890b279b4aa889390baedad7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41ef30266bc2fd87238ba65b90f8d3e90f208f846c00425babebef6ed9d679fc"
  end

  depends_on "python@3.14"

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/93/44/a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7/funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")

    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{libexec}/bin/python test.py")
  end
end
