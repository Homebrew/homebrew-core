class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/05/57/4517c2a472db23df6a46a87b9f0d22483bbbbe74589156e70622a01b1671/fonttools-4.21.1.zip"
  sha256 "d9cf618ab76afb42a79dcc0b4b5e5ee7ec1534f7ad9da3809bb15ddfcedc073d"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25c8519b23db28176bc64e04e689b3357851c57a391638762a6d5b734df364e3"
    sha256 cellar: :any_skip_relocation, big_sur:       "81279f204344f80a429c3ded21e71134a7a3cd4052b6d6d8fcaac1886acb3ba2"
    sha256 cellar: :any_skip_relocation, catalina:      "7cfc50aa8cafeb3ff4529196c4fbbe8eae641be25599fa30c545fc1192029abc"
    sha256 cellar: :any_skip_relocation, mojave:        "dc57fb513859a2734d2d07d6842e76aead61d54fc92ce5849e9b2668b5b3698c"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
