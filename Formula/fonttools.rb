class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/3d/f9/ebd619f1393d4536bbf4becb9ffc41d95d01b38441244b28fa39b827db4a/fonttools-4.18.2.zip"
  sha256 "5c50af6fb9b4de4609c0e5558f3444c20f8632aa319319a7ef14fd5ba677c9f8"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a9f36af7ec6c64152dfd95f875fe00d3a3e11a7b1b1bb80425ac8bb435aa19f" => :big_sur
    sha256 "a10eb2cbd10dcee3579acd1c7ad6a4cee20d3843883f9b2a957cde9a5dffe3b6" => :catalina
    sha256 "8e85e062949689308c138692222e140a29a8ccb21da7349936fcb5498c082667" => :mojave
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
