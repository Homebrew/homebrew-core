class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "http://cimg.eu/"
  url "http://cimg.eu/files/CImg_2.1.7.zip"
  sha256 "da36831b61136bae4605d7aebd399821040a8fd4717a8a2ba199cec9ef12e6fa"

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
