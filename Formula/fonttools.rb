class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.7.1/fonttools-3.7.1.zip"
  sha256 "ba33c8bb210e66bdab1fd99ed09941dddc0eb9d0b78c6097157699eae2b731d4"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "715b3e1dd1da5934090cd77b8414f7882fe92429bb74732de009e662b8030f58" => :sierra
    sha256 "e4efcdde6daa7bd010d1b67813dc6a95a63038b7498b73fd43e311c5165a9035" => :el_capitan
    sha256 "3a33de7b8a3ddba99ca495ffa651942c4d2a22f77bb29f787811fe7e9262b14e" => :yosemite
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
