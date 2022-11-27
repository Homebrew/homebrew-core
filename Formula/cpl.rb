class Cpl < Formula
  desc "ISO-C libraries for developing astronomical data-reduction tasks"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "ftp://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/cpl-7.2.3.tar.gz"
  sha256 "0b18ae87786d1f9a3cddd841464a6ec2f3339989eea9d5ef84a4b8a1e4ce68da"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cpl/"
    regex(/href=.*?cpl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3851c7f58809902fc9c424f0605a84c5d6185a46cd72fd6eb59dab119da5abf"
    sha256 cellar: :any,                 arm64_monterey: "d8fa5d505932b8dd95630862595bb08968cab15aa283db26b9cde635f84ec356"
    sha256 cellar: :any,                 arm64_big_sur:  "02c5c4b357de2c6bccd1b78549441d8d1ff6b3b03b51a005bad66b1bbf6555c0"
    sha256 cellar: :any,                 ventura:        "17d71f59448d62a12f237f2fe1517935bfbd83f5386d137d4e5c9b1e11d3718b"
    sha256 cellar: :any,                 monterey:       "6139cbb88732334d574378460b9c3446b809d24b9fcdd108ba301097e7ad83c7"
    sha256 cellar: :any,                 big_sur:        "8440862ae12cacc1db0d4b4d8a404908a9a9ab8563799ee838f48d5975668885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15e376dee4b4f4bd0b3afe53d9066ebdee4c3373b4b397723a2b2412246bc8ab"
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
