class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e9f95151d330c7a7aa6c7e72f07195d0b0f06d4ccce0b8cda836a2c11c7d4a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e695864bea478332177a297ae94adc1ed1802377f77d47e8f19262d0510e13d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56e3f05cef4125a8fa5d8fae848717fe5513fc005c9cea9d6978c19585b0394c"
    sha256 cellar: :any_skip_relocation, ventura:        "4a6d0d89edf70a46713004e8fcb7b42d02bdd2c30060f5fd5ba5fd67953ce269"
    sha256 cellar: :any_skip_relocation, monterey:       "691dda7c94af327a1f89bc24dd71e37c05a531d44cd2a04bdd2b3b79d3a6dc37"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc62a189cae938ea048f96de7cb1277400d897a0e7b7c0240da76eaa5e7c7d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1f50885395e40add7f605e0004c2767f4faf05e983b129e2594078ed61a4b4"
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
