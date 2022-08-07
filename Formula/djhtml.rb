class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/26/8f/b838a00b9fa0033c210e5fddb43d41ac3f500decf840e6b251ea18c3da6e/djhtml-1.5.2.tar.gz"
  sha256 "b54c4ab6effaf3dbe87d616ba30304f1dba22f07127a563df4130a71acc290ea"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33348a92e025ad63d5df5279f2e87bb5d0140cd321cc3259f30927f6efbbaa68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bcc95cfa90669921d18ea1797941a84b112418c12ea6bcb522fb92d44fab390"
    sha256 cellar: :any_skip_relocation, monterey:       "2e4894c67a29ee8d633e74ee36c8782d1c1f6c6e8be5df9a50356632924badd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "78149d6722ad72850eb5c9a9bd7aa0a2d5c229de2c9b5ac4cbe7d364982f531d"
    sha256 cellar: :any_skip_relocation, catalina:       "0b4a0aad7ff5b1d814440942a2fc55cdf28bbc37c24dab659b3cca232edf83e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b67309e35b9d2af10b58827f57ee1e194352fc5216c65d3450064cad2ae51e"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.html").write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF
    assert_equal expected_output, shell_output("#{bin}/djhtml --tabwidth 2 test.html")
  end
end
