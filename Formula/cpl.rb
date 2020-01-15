class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/index.html"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.2.tar.gz"
  sha256 "b6d20752420e2333e86d9a08c24a08057351a9fef97c32f5894e63fbfece463a"
  revision 2

  bottle do
    cellar :any
    sha256 "eaa25be68d177d79c5fe055f6d73645ef732d02a9931ab8dfc1318a4eb4d715a" => :catalina
    sha256 "21b7a53811f9d461622fd1dd7c5e37d5cef25804850600f6c0fecf75ee219b9a" => :mojave
    sha256 "b41948717b7319960d2e59bd2c25886da16f79184b21f2f2675f90ba42f6af40" => :high_sierra
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
