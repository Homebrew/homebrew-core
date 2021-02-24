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
    sha256 cellar: :any, arm64_big_sur: "fcc333aeb18c1c3ae29de030f7eca67b72f5dd688d2fd5d609208722dc669bb7"
    sha256 cellar: :any, big_sur:       "fdfd479b8c8f52b085f4b04b65dc4c8a2117598180dc6ff4d5b335910d9ac614"
    sha256 cellar: :any, catalina:      "7fbc74cf613b6247bcbba46ffced1b1436ab7fbee5a53e5c7493eb5b4f9b29cd"
    sha256 cellar: :any, mojave:        "70f2086f3529c963bbbf9b09069ff29c39d244e49c85decbcea8b6d99642315e"
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
