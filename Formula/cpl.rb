class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.3.1.tar.gz"
  sha256 "54546d763e7f75cb679f711c62bc962211328a35064edb6b9455e306458ebe15"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bad7979fecf86da06cb306c6a00a16a40370452a4c0b4f994331f04bb78e1419"
    sha256 cellar: :any,                 arm64_monterey: "1ac331b2ec31beb396b54264445f11bed88ffc71fba99510907ba59f59c3051e"
    sha256 cellar: :any,                 arm64_big_sur:  "20b5ded33184328a219f424fffef0ef75181844f6b2185ba3ddd2156778c98ae"
    sha256 cellar: :any,                 ventura:        "d160f167805735de6d96c9638d3a402e1c001f77ae8b8317390e988c0049acce"
    sha256 cellar: :any,                 monterey:       "1f20df9a017b56086461f97ccdfa7b8928a70ff8a9e76669cd96bf10314d5e10"
    sha256 cellar: :any,                 big_sur:        "fc9d98fb32cbeaee37ed9b56dd2f04403599c7c1e8b000ab72a5e35436aebd85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c0f41d4deb1de802c8fa6fc192c4498559bf14afea13ccb19e94ee1b893f257"
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
