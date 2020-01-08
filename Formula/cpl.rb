class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/index.html"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.2.tar.gz"
  sha256 "b6d20752420e2333e86d9a08c24a08057351a9fef97c32f5894e63fbfece463a"
  revision 1

  bottle do
    cellar :any
    sha256 "7a5667467ab4c28461936beb3d10e0b78643d101195f2c770458c791a5036c6f" => :catalina
    sha256 "bc075ecea64ebf2596b76e7d22da34d7fbcf931b0be73178295dc6e60c07fe71" => :mojave
    sha256 "35c344b9fe12a202c5993050832d68a0621a1578eddc5b57da16237c30c481b6" => :high_sierra
    sha256 "61a2907e35bc4e8ebe4d72a82c526b1d40c495d0f9525283c3ec3e56718057f5" => :sierra
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "wcslib"

  conflicts_with "gdal", :because => "both install cpl_error.h"

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
