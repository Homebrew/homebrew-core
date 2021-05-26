class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/26/56/19ba6c01a5c93c0a8cd35f54027133d7a076ef6adfd7e076099c17ee16ff/fonttools-4.24.4.zip"
  sha256 "df7fab667b039cd2a00a1fffcba73a32b2c630ef2a12ab7069ef6df5333f20c3"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "56a35c6887ccfcbe7856dae88062a7a518ea983f45b8f4a734bd5b997ff60b3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d33777171d3c51372ebc3f9056b55e8c247e3cd52efe0043815436d0f35546c"
    sha256 cellar: :any_skip_relocation, catalina:      "6d33777171d3c51372ebc3f9056b55e8c247e3cd52efe0043815436d0f35546c"
    sha256 cellar: :any_skip_relocation, mojave:        "6d33777171d3c51372ebc3f9056b55e8c247e3cd52efe0043815436d0f35546c"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
