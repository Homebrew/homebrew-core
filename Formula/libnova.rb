class Libnova < Formula
  desc "Celestial mechanics, astrometry and astrodynamics library"
  homepage "https://libnova.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnova/libnova/v%200.15.0/libnova-0.15.0.tar.gz"
  sha256 "7c5aa33e45a3e7118d77df05af7341e61784284f1e8d0d965307f1663f415bb1"

  bottle do
    cellar :any
    sha256 "2bcc962108ffee6fafeae45e5b9eb8f6b233bd2aaa0163f6c89e2f77ddc6eb3f" => :mojave
    sha256 "08345c100121f219e199a833563b8f35d17e5368b93e3711377cc20acd0dce99" => :high_sierra
    sha256 "1ef1a9898b97967ba9cabdf002ddcc4b398976f0c9bb7c826f7980ffaef87dd4" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libnova/julian_day.h>

      int main(void)
      {
        double JD;

        JD = ln_get_julian_from_sys();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnova", "-o", "test"
    system "./test"
  end
end
