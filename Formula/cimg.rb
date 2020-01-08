class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_2.8.1.zip"
  sha256 "87700b42b60c5048eee026c536a689205ba09baf994fb72773a3e805dbf3b64d"

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
    system "make", "-C", "examples", "image2ascii"
    system "examples/image2ascii"
  end
end
