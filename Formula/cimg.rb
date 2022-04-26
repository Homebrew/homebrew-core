class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.1.0.zip"
  sha256 "8c5392ac57764bdaeced142f12c8a79c8dd93277dc61e90dca6b7e1e25cdb01a"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b7283b2ee43a8e2c3b54937e4592f26a934c7c7d64336af9d25ed1fc6ec51743"
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
