class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.24.1/fonttools-3.24.1.zip"
  sha256 "d13e98c9f3b635a5334dab69eb471d7286928ac82db7ca57b5bf4cdf3824789a"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b8d83894012b281a45bea0ca83708b43c32471d67167a34ee4f029927f5fa9e" => :high_sierra
    sha256 "0670536165a9b955f802e89a942476bf8b131414671294bec59befd60d7210ca" => :sierra
    sha256 "2c3ea7a2664d3e9f6632737c4a3d15a8fa04c4cab3f4d208c316a904df27931e" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2" if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
