class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.4.tar.gz"
  sha256 "63171467e9deab880842f3e5589c02698c4637cf75106c4aa39affd84ecd8bd4"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "662a3df38c271a2f52a278f4a2c33be05c988143ec4372c939fad7b613c496a4"
    sha256 cellar: :any, arm64_sequoia: "6be5591ba836b44df499c525a07ae1b921b173b04ddfa1fe1f21f831a4cc7318"
    sha256 cellar: :any, arm64_sonoma:  "a8a14966b0f071696bd98f8adc878982f40e4e855491a2c57b42a2fa7dedc3ce"
    sha256 cellar: :any, sonoma:        "c1558be21fc2294bf314d57fac10925f52e1f97c85de8352aeabab9a5be193e1"
    sha256 cellar: :any, arm64_linux:   "bd69c8afedad60bc4e91aee09ac0961c7f627011c5d4141ef65917cef0f435ee"
    sha256 cellar: :any, x86_64_linux:  "1751a96a8ee0576374dce19027f4e18e2a259fb752b322736964cf9d7af009b1"
  end

  depends_on "cfitsio"
  depends_on "fftw"
  depends_on "libcext"
  depends_on "wcslib"

  conflicts_with "gdal", because: "both install cpl_error.h"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-cfitsio=#{Formula["cfitsio"].prefix}",
                          "--with-fftw=#{Formula["fftw"].prefix}",
                          "--with-libcext=#{Formula["libcext"].prefix}",
                          "--with-wcslib=#{Formula["wcslib"].prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cpl.h>
      int main(){
        cpl_init(CPL_INIT_DEFAULT);
        cpl_msg_info("hello()", "Hello, world!");
        cpl_end();
        return 0;
      }
    C
    libcext = Formula["libcext"]
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcplcore",
                             "-I#{libcext.include}", "-L#{libcext.lib}", "-lcext", "-o", "test"
    system "./test"
  end
end
