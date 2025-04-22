class Djhtml < Formula
  include Language::Python::Virtualenv

  desc "Django/Jinja template indenter"
  homepage "https://github.com/rtts/djhtml"
  url "https://files.pythonhosted.org/packages/9f/e8/1919adec35e3a7e02ec874b7a95b811f03ad6dc9efcfe72d18e0a359f12a/djhtml-3.0.7.tar.gz"
  sha256 "558c905b092a0c8afcbed27dea2f50aa6eb853a658b309e4e0f2bb378bdf6178"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f04ac1e5d07cff0015fd4bdc56e8f96b67a16836f1a4c7f31392f1f92c93033f"
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
