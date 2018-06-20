class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.28.0/fonttools-3.28.0.zip"
  sha256 "ebf2ee25a6060e8551880a3b05d6ecadcdcfbd1b32fc272ff7b3acdb22945b6f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e97c8b9398a87e56a2e6fa3ab02f194add28c8e3dcd349dd6b6e9d88bc718e13" => :high_sierra
    sha256 "4399c50d97947a4922b1fd01012816e7d8ea9fd737cc620d5b25c4b6f2d3f0ff" => :sierra
    sha256 "bc866f3936e0f98b3794550eddffe80d3622df2644bc4a4245d212dceb49d3ac" => :el_capitan
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on "python@2"
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
