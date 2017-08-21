class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_2.0.3.zip"
  sha256 "054cdc84e345aa41b048f6221b18656aea2ebdeb33b693ce876a5e1603d23ce8"

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
