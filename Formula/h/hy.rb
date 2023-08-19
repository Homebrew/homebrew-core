class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/93/5a/47276218f7419e134c659061150aeae2bdd80d7cfbb814447b466b59d546/hy-0.27.0.tar.gz"
  sha256 "5d646e32b01fea740057b856639c672489d27ec7f9cc882363951c748d2b5ceb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99df8063944e29bbed30139a63e51dfa53fb57b4c3b3d7dd0e1b45e8f6e28a1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49b43ece3869b0c1d72b07520d78f90ca30d596adebe9671d226e1cca55f9c60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d685cb144ef2c1bffbb0be0e51cbc46890eedcada3370142cfbfd4e1a3bcae"
    sha256 cellar: :any_skip_relocation, ventura:        "a130249a9cefc514995672692d37a26a0f8acf1484f0fdf800f5ae276c2c8136"
    sha256 cellar: :any_skip_relocation, monterey:       "7d68a3d749219788fba9bf2c8606bbf078bcb7000cb83ed0a41c6ea1616733e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fb6e62c38f6b1ccab054d67eee72bb2fdd92a2b6da3be2d728d4bb70c6757fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "173fa3e81b16d33395011549ee1d90c0ced357e83008975715a37f01f8541fa8"
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
