class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/26/8f/b838a00b9fa0033c210e5fddb43d41ac3f500decf840e6b251ea18c3da6e/djhtml-1.5.2.tar.gz"
  sha256 "b54c4ab6effaf3dbe87d616ba30304f1dba22f07127a563df4130a71acc290ea"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4adc528310393b337a0db8f2ac6997671f967213c63f827bd2a837c15d625e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f208b0e5db6076c96817c5bdc98d856cf6ccf157992caaf8beef29ed1beb4a58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6e08bfdd287ad597d669080c06d31952a5723868b5c4391cb299284c5e4d86"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d066cb4353341e6f36a7e5cc74927370330e80bc2a369fb351e4c6ea1f8a04"
    sha256 cellar: :any_skip_relocation, big_sur:        "7616b050d59d6be9c373a6e3f3ea415ce5bd46fcad14453b09a3f295700039f6"
    sha256 cellar: :any_skip_relocation, catalina:       "c6fbd2e56df3a8441a0eb468f81922e6b457aac336d2f2113bc8276424962d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2cf279087581551f44cc9b757d9311502a3003bb329c74a4f0446e0c73846c"
  end

  depends_on "python@3.11"

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
