class Hy < Formula
  include Language::Python::Virtualenv

  desc "Dialect of Lisp that's embedded in Python"
  homepage "https://github.com/hylang/hy"
  url "https://files.pythonhosted.org/packages/68/bb/8f852a2a9591d53c083384f6cd95d9e857b2802668f922fa0b50468a280b/hy-0.24.0.tar.gz"
  sha256 "de3928ff7f97893bb825e59f17f3cd19e4b59beecb71c38039b8f349ca8dfe1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a538543a1b70f34b5c061a40bdb0ec3371a58ad4ba5df0d7dc6f446239ae6710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712c76f2277c050cb51d9eb07097e954f53af8292f3e9816a817675596bc8542"
    sha256 cellar: :any_skip_relocation, monterey:       "2648a502028e4543904df11c1a014a37707f1f63449b710b4550048cc60aa149"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ef084c743b02e21824fbfe80e8f218681d7aa4354be7ac91db4a33fbcfc8111"
    sha256 cellar: :any_skip_relocation, catalina:       "ad354e53f9f56725578da4ef9f577e72e170b8986bd652753b8ee165438f78d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bd60feed6ccd186b760a74eeedf186e9deaad3f7287ded6e81a043fa39a4cb"
  end

  depends_on "python@3.10"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "funcparserlib" do
    url "https://files.pythonhosted.org/packages/53/6b/02fcfd2e46261684dcd696acec85ef6c244b73cd31c2a5f2008fbfb434e7/funcparserlib-1.0.0.tar.gz"
    sha256 "7dd33dd4299fc55cbdbf4b9fdfb3abc54d3b5ed0c694b83fb38e9e3e8ac38b6b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    site_packages = libexec/Language::Python.site_packages(Formula["python@3.10"].opt_bin/"python3")
    ENV.prepend_path "PYTHONPATH", site_packages

    (testpath/"test.hy").write "(print (+ 2 2))"
    assert_match "4", shell_output("#{bin}/hy test.hy")
    (testpath/"test.py").write shell_output("#{bin}/hy2py test.hy")
    assert_match "4", shell_output("#{Formula["python@3.10"].bin}/python3 test.py")
  end
end
