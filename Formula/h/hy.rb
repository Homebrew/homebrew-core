class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/88/53/e92bfd8a36dc4a62e0922d409f703299eac8a0a74ed4db2106acad4f00a0/hy-0.29.0.tar.gz"
  sha256 "1f985c92fddfb09989dd2a2ad75bf661efcbad571352eb5ee48c8b8e08f666fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bab260cac5449586ba47b527990cd1e4f3dc1f74461b18a4231ba7103c62547c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0621a28e341f9af1e3809a4276ecbab61cbd2c722b913b069fa3deadcdbb1881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41b1022eb4b374e9fbd341ffd0e976b7c232776203cfc1ceea7b2938879fb6c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f4f12dfa2db324f4df20abb6cb1d301a45f1a22d2511b4ead5abf6d32214534"
    sha256 cellar: :any_skip_relocation, ventura:        "3f61cd38bc97e453c4fbec448c776ac1d5d29246afe73efc7e10d16e726a6200"
    sha256 cellar: :any_skip_relocation, monterey:       "164b718ad1443e523b08675f086b5a8a04e32e982a788a4fd1a555e0e767c9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb45f61f54b6e4804a6483766f59f66aed26e755fc75ff21de7bebf239ac7ab5"
  end

  depends_on "python@3.12"

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/93/44/a21dfd9c45ad6909257e5186378a4fedaf41406824ce1ec06bc2a6c168e7/funcparserlib-1.0.1.tar.gz"
    sha256 "a2c4a0d7942f7a0e7635c369d921066c8d4cae7f8b5bf7914466bec3c69837f4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    python3 = "python3.12"
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{python3} test.py")
  end
end
