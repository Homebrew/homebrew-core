class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/4f/65/4e9976d7dfedc2c929534de8455bafa7b78b621a6bb18e9a4d0e19b9d89d/hy-1.2.0.tar.gz"
  sha256 "fa1a193fb2ccbe977681b15cc59094b2ee5ff4e22119fd723f8a35951003cf76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7cf2d933c6cd5c65016cd864911408242516bba32cba3f17a79b442569030ea8"
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
