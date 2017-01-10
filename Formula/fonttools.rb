class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.4.0/fonttools-3.4.0.zip"
  sha256 "12949c451af8db545e8a239f54312eb7b37977a0b946a85bcbbc28f8fcc1a4d7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a7d2d6e3eb97cb360b3c00d4406faad2e6de5f414a4f9ad3175115be01f9062" => :sierra
    sha256 "76a2a12377583a7ae2f43d7bffb1dd56c350adcffcfe58a63558a0394f4d4a73" => :el_capitan
    sha256 "10d261359af40f0f04bb505c61e99509526df0ff583351970a30cee824597b9c" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
