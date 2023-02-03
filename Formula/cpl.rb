class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.tar.gz"
  sha256 "f4e0578ec211f934cf973c46ab2a3c9ca51e17578ef4087e5cc6a04ec5d61289"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c4457137efca6354a8ea72a9075888a0eea87592c67877a8f05b7c56b233c23"
    sha256 cellar: :any,                 arm64_monterey: "20f83e505566f0631d7b198893f308b7f043a551f28832ccd5e63ad91c5b4eda"
    sha256 cellar: :any,                 arm64_big_sur:  "42d6669c08ce7e1d579be68fc963538e594f58760cfb63b7efea66b48ce0b048"
    sha256 cellar: :any,                 ventura:        "391461d78a67f1ea130b0772eb11dbe9c9ed10a99d4eb906087f5cc1ce0b877a"
    sha256 cellar: :any,                 monterey:       "690a5653359f54bc206db50b57e152fa5fa7bb0b93440e0598d73ecc18bc3eaa"
    sha256 cellar: :any,                 big_sur:        "0e7624192f76ac7b3813826f07e0b18e9e638a87128f292ba78b5bbf17d960bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69631a7f3deb433997beae6ddee746c36ea0c60d287ce862a097bc4974c9f437"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOF
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lcplcore", "-lcext", "-o", "test"
    system "./test"
  end
end
