class Libnova < Formula
  desc "Celestial mechanics, astrometry and astrodynamics library"
  homepage "https://libnova.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libnova/libnova/v%200.15.0/libnova-0.15.0.tar.gz"
  sha256 "7c5aa33e45a3e7118d77df05af7341e61784284f1e8d0d965307f1663f415bb1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea8ac3b10dcebb0b96b1d6f1ae08b71be65186fa64c8c4e5b06b512092608b6d"
    sha256 cellar: :any,                 arm64_big_sur:  "4b63bdd901dfc329c9c6caf41a0bb370f5b459f21ec5b09366c364156c38bd06"
    sha256 cellar: :any,                 monterey:       "0d520f6d78a8f7cd971fbd36897cb9d442ee2da93c3701d724e8b4eb7195858f"
    sha256 cellar: :any,                 big_sur:        "73650301b811cdf4d5aaaab55961708ac3ccede6900f61222a3dcf94a0b9f4fe"
    sha256 cellar: :any,                 catalina:       "d7f6515e6a018fd9b9fb47d25610e62cef4f0953fa3c33c7fb3499d5ed0e3f1b"
    sha256 cellar: :any,                 mojave:         "2bcc962108ffee6fafeae45e5b9eb8f6b233bd2aaa0163f6c89e2f77ddc6eb3f"
    sha256 cellar: :any,                 high_sierra:    "08345c100121f219e199a833563b8f35d17e5368b93e3711377cc20acd0dce99"
    sha256 cellar: :any,                 sierra:         "1ef1a9898b97967ba9cabdf002ddcc4b398976f0c9bb7c826f7980ffaef87dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41b0f8cff7affaeb1f8df48a2f13e4ce0fda9ad886c73ec3ada492cd1c9e862c"
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
