class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/eb/4e/30dbda9961e5eec63606c8d2fd08ece12f28244111df05a79adac2b02f37/hy-1.1.0.tar.gz"
  sha256 "c8943ce306341b4b3edab4142f2c7ca55b43415b0ebf6c0e7969290a6eed2948"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06373055a6ecfc7909dbc3ac76d49381920669abd8e375bc1c96317f0f05dba5"
  end

  depends_on "python@3.13"

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
