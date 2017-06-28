class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_2.0.2.zip"
  sha256 "f909e37532bfec6dbc675eb9945e1bfb2c94b5b108462aa51361fe94f2650c75"

  bottle :unneeded

  def install
    include.install "CImg.h"
    prefix.install "Licence_CeCILL-C_V1-en.txt", "Licence_CeCILL_V2-en.txt"
    pkgshare.install "examples", "plugins"
  end

  test do
    cp_r pkgshare/"examples", testpath
    cp_r pkgshare/"plugins", testpath
    cp include/"CImg.h", testpath
    system "make", "-C", "examples", "mmacosx"
    system "examples/image2ascii"
  end
end
