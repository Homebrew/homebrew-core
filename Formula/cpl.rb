class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.1.3.tar.gz"
  sha256 "04109613819b97273045102bd7acf52d13ee7f9217779f17ae2a170c491965c5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.eso.org/sci/software/cpl/download.html"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "7ebb518afea5306674b1b4fe01826e3e3f3531eaf5f0d87069df31f88475caca"
    sha256 cellar: :any, big_sur:       "740461b2b2bde934347eec401daa1322bd54d726c7ec9902561a629042bfa16f"
    sha256 cellar: :any, catalina:      "458b9de38a1e292da0e9d70b453dc7ca8bc199b253c2a1120bb61d608595497c"
    sha256 cellar: :any, mojave:        "dcaa92d135d443432230d2ac087f73f87e515959d42950eeb19419aebe926158"
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
                          "--with-wcslib=#{Formula["wcslib"].prefix}",
                          # Needed for 7.1.2's ./configure to work under Xcode 12:
                          "CC=#{ENV.cc} -Wno-implicit-function-declaration"
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
