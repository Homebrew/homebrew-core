class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/68/4d/0df3e733e56b6e5c81260d77d8d3c1776c9fa19a188deda801f63b304869/djhtml-2.0.0.tar.gz"
  sha256 "7f58b7f7ab0bc3f7a2ae2a9639a3684929bbe85f3aed34404285eacdb4e47300"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4adc528310393b337a0db8f2ac6997671f967213c63f827bd2a837c15d625e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f208b0e5db6076c96817c5bdc98d856cf6ccf157992caaf8beef29ed1beb4a58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6e08bfdd287ad597d669080c06d31952a5723868b5c4391cb299284c5e4d86"
    sha256 cellar: :any_skip_relocation, ventura:        "0d467998a2ff88d61a63b33d979346ce9331c035bc7d8c6091939e95a47709e2"
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
    test_file = testpath/"test.html"
    test_file.write <<~EOF
      <html>
      <p>Hello, World!</p>
      </html>
    EOF

    expected_output = <<~EOF
      <html>
        <p>Hello, World!</p>
      </html>
    EOF

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
