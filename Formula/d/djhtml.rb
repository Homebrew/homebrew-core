class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/a0/03/aac9bfb7c9b03604a2c4b0d474af22731ef41cb662fad07f956ae7bf0f6b/djhtml-3.0.6.tar.gz"
  sha256 "abfc4d7b4730432ca6a98322fbdf8ae9d6ba254ea57ba3759a10ecb293bc57de"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "5896d87d6f0ce879311a77868797561f6d41020fd316b0c4e4dbda7f1a7e51e6"
  end

  depends_on "python@3.13"

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
