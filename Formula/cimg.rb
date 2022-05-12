class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.1.2.zip"
  sha256 "041d028b522e23283b2402339e315591d3b9611fa5762de6ad733ecd8a1138c8"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d44f3208c8a4a6c09d1f51cf32c78e12c3cac12875a60525314dd6a570b0ba7e"
  end

  on_linux do
    depends_on "gcc" # C++ 17 is required
  end

  fails_with gcc: "5"

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
