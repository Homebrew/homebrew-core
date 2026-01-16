class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/76/dc/7d2a8e1e2a5054a50c328e02b4704179b80a8fbf0535bde793d85840c669/djhtml-3.0.10.tar.gz"
  sha256 "dd4ebf778d3b7da7a6e6970f7e66740f08ed7485485491b9a80527f526c838d9"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2b5b263bf539b7f64e2f460e18dabf549fe8cc70785333fefb6ecb66f7e472dc"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.html"
    test_file.write <<~HTML
      <html>
      <p>Hello, World!</p>
      </html>
    HTML

    expected_output = <<~HTML
      <html>
        <p>Hello, World!</p>
      </html>
    HTML

    system bin/"djhtml", "--tabwidth", "2", test_file
    assert_equal expected_output, test_file.read
  end
end
