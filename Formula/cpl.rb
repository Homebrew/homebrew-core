class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/index.html"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.tar.gz"
  sha256 "ba7f762fac3550e9d9246b7fbacba54bfba4c47b833720834bd4cd21ed0e8b00"

  bottle do
    cellar :any
    sha256 "3dc5ca15d5d77e85f0110ef70f97904759587c3a4bc35b6b967ab6d0a346d31d" => :mojave
    sha256 "699080f73aa0a34d32d29d984057cc4f5f6ce8377951979687149fad93e063a2" => :high_sierra
    sha256 "20e309b283fa09e0ee0adf876f2659c6f40ad2114101ebe4807ef9965c3b7fde" => :sierra
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
