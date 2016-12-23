class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.4.0/fonttools-3.4.0.zip"
  sha256 "12949c451af8db545e8a239f54312eb7b37977a0b946a85bcbbc28f8fcc1a4d7"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a10728a021073eded47053b23a843bd1f656ef0b75641e80b63ad08c92678d2" => :sierra
    sha256 "d049cb3ab859a2e9859fecede2f5670b820b42f4fc420707f4fbe6eea13b7423" => :el_capitan
    sha256 "647b79b78919987f354f0529a85be8d033a2f7611dd195477d5de3cea0b09381" => :yosemite
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
