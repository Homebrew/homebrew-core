class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.9.0/fonttools-3.9.0.zip"
  sha256 "b4e2597812dccbbf78d02013376981749c77ce1df17a61f9b78f02faed9929aa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c8de427e0349aefe0ddfb1685a1964653f238d4114dbe5e1c7358e09fb408d3" => :sierra
    sha256 "1f33f8748e5d3f6e86c5cb949eccadc30b010f6745f324966f6d19916d17a50f" => :el_capitan
    sha256 "80eaebe880db19039eb668afd221874ea673174777d083ef79b828f4d28ab8fd" => :yosemite
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
