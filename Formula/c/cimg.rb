class Cimg < Formula
  desc "C++ toolkit for image processing"
  homepage "https://cimg.eu/"
  url "https://cimg.eu/files/CImg_3.6.5.zip"
  sha256 "f1cfd17871032815f38f42a1924b75c64b942f4db5fecd9cacdcb41988624d8e"
  license "CECILL-2.0"

  livecheck do
    url "https://cimg.eu/files/"
    regex(/href=.*?CImg[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d92b69822c309335264fdd40fe70ef7123a8946ad889d23ad0adf7cafc1473e"
  end

  on_linux do
    on_arm do
      depends_on "gcc" => :build if DevelopmentTools.gcc_version("gcc") < 13

      fails_with :gcc do
        version "12"
        cause <<~CAUSE
          Fails to compile because of undefined `_Float16` type
          https://godbolt.org/z/nKbrjPTvG
        CAUSE
      end
    end
  end

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
