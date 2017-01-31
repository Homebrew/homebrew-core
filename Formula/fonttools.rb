class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.6.2/fonttools-3.6.2.zip"
  sha256 "50d38d53b61198fa7ede4042b1f1656532232a679272c5af67d3f1bb8629a320"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4760ecea204db5d792127a7eea62d810fc76dc71b04ae983a805beb2959b8232" => :sierra
    sha256 "75f1fb309d4bca20c20d2b569559768012826480b9f731bf877fd890664a5ccb" => :el_capitan
    sha256 "9cd74532c8266baed1cca3fdfe79879af7944648b4c4d2ccf5010fcddd613b29" => :yosemite
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
