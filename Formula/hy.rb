class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/fc/d1/95dac7cb3e3a483cf53a8c18f529f50c619e6a4ee42b299802ca769dc174/hy-0.25.0.tar.gz"
  sha256 "50ed88834b03a33fc25b85d8897bbe15b7846b84d324630ace8d052f7d48327b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a538543a1b70f34b5c061a40bdb0ec3371a58ad4ba5df0d7dc6f446239ae6710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712c76f2277c050cb51d9eb07097e954f53af8292f3e9816a817675596bc8542"
    sha256 cellar: :any_skip_relocation, monterey:       "2648a502028e4543904df11c1a014a37707f1f63449b710b4550048cc60aa149"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef084c743b02e21824fbfe80e8f218681d7aa4354be7ac91db4a33fbcfc8111"
    sha256 cellar: :any_skip_relocation, catalina:       "ad354e53f9f56725578da4ef9f577e72e170b8986bd652753b8ee165438f78d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bd60feed6ccd186b760a74eeedf186e9deaad3f7287ded6e81a043fa39a4cb"
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
