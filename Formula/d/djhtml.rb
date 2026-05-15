class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/22/57/5771714b5961b7ee275a5696cabc3bd8c4a602d7cca103a44016109509fd/djhtml-3.0.11.tar.gz"
  sha256 "dbaf55684294bda6486a094954e43847a1c0945e521282e008a9aabdac245688"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a045b1f5b2f623dc7c0cf54671e740cf0de9a09af84e59b9448cdc6b8b5c80ef"
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
