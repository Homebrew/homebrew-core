class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/91/1e/de3ff93dcb16de04b12b570742e03e4d741106e9721c1a5a0bb53d450e08/hy-1.3.1.tar.gz"
  sha256 "cf7b85fc59079b5da794c7ecaafc6a6e9140f73305af03836c3d52cf978b6645"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55a855467c2c228192b035fda862aff04c62e857b383f8e170540d7688f81665"
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
