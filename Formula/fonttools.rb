class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.9.0/fonttools-3.9.0.zip"
  sha256 "b4e2597812dccbbf78d02013376981749c77ce1df17a61f9b78f02faed9929aa"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e06bafc20d95c8c4a2fb569750c33e51f9c14598c1ee75f8e599f84fceee64ec" => :sierra
    sha256 "198976bc419d5058fa7471ef09b6c2bf7a655c6b5635b82afb5000e57e36c381" => :el_capitan
    sha256 "cd7d40b7b54a0b003068f339f1b9b0e17dde2af6389f3a684ba506d3b8c67710" => :yosemite
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
