class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/49/e8/c2d12facfc47fec732633ea3c2d820298e0e314331fc43bcf694099abcb5/djhtml-3.0.8.tar.gz"
  sha256 "ec3b4cf25f0959474c7793da1becba654ca9587689ce143955bcbc2638eeabce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30c255ebe8bca9d8a0251eb1e4eab05d094bb499104dcc5736a899481ff24826"
  end

  depends_on "python@3.13"

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
