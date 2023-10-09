class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/93/5a/47276218f7419e134c659061150aeae2bdd80d7cfbb814447b466b59d546/hy-0.27.0.tar.gz"
  sha256 "5d646e32b01fea740057b856639c672489d27ec7f9cc882363951c748d2b5ceb"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f3e50169286f11e6c46a82d1dc06c1de366100808fc34b9e4edc884c44857624"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24be88bca02ceeb4f1a6852a1a49e8893fe5314a9c28b3996f1b55ae7060ddb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6337ccc5d5609766bd4d2d9d745e2e17fff8879e3e4639d64754e3fd1b8c8b17"
    sha256 cellar: :any_skip_relocation, sonoma:         "bda17f1e94b64a48e39a5cc27d5f97ed4b37051d36c161d2d9c170af76363d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "9f1ed1fc3640d905e95f835e810c1a8456d7ed2903f4e8c2e0f9c213bbdf9cb4"
    sha256 cellar: :any_skip_relocation, monterey:       "a4d2e10028d7d50c42c65c802ba9009319f8b22c58565601a6fef74f56a355f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "109263044c360ba6269cd4af560a7ab1838b9d47a2e4974dc9f2b12d80c1e2b7"
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
