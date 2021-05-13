class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/e1/dd/e78a32ad831673e33dfc2565f7ffa90cc514688c267f400104bfbb8b0be7/fonttools-4.23.0.zip"
  sha256 "55f5a6474683ca96c50b71ff103d9766a9bcd8a0e90cd7272bd8e9c5aaaffdd7"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5589ef5b8244b1d46b5041f46d310577511888d0f3381eeae03110c8044f066e"
    sha256 cellar: :any_skip_relocation, big_sur:       "d85f673b819b68d0789e869134790dc0d774ce28ee2c74a5db9abef769081e96"
    sha256 cellar: :any_skip_relocation, catalina:      "d85f673b819b68d0789e869134790dc0d774ce28ee2c74a5db9abef769081e96"
    sha256 cellar: :any_skip_relocation, mojave:        "6dc02159bbb1cbaf5abd44d5cfab2b114b14d11e4435ad2e8753997f99038f28"
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
