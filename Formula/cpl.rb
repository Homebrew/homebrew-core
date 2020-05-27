class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/index.html"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.2.tar.gz"
  sha256 "b6d20752420e2333e86d9a08c24a08057351a9fef97c32f5894e63fbfece463a"
  revision 5

  bottle do
    cellar :any
    sha256 "477077e46d63da4596429a0f71012969a8bec6a91db94aa838a7e040c18713c7" => :catalina
    sha256 "64c1e2fb6caadfcdb36731d7e197dd234a03afbe531ce0d418fe05b4719a96d3" => :mojave
    sha256 "8959f7d8558635bf89222d668ab7ef4f6f91059652350c74bc493d17d66b7c54" => :high_sierra
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
