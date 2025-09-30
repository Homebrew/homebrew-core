class Libnova < Formula
  desc "Celestial mechanics, astrometry and astrodynamics library"
  homepage "https://libnova.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libnova/libnova/v%200.15.0/libnova-0.15.0.tar.gz"
  sha256 "7c5aa33e45a3e7118d77df05af7341e61784284f1e8d0d965307f1663f415bb1"
  # libnova is LGPL but the libnovaconfig binary is GPL
  license all_of: ["LGPL-2.0-or-later", "GPL-2.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "cf36faecd4340aba9996e78e9fb65737956fe1b102ca98627ca5259a1b316728"
    sha256 cellar: :any,                 arm64_sequoia:  "7c78e76239a8d99361a578d2726073d7cc300261a68effe3c189dd1edc2fbb4f"
    sha256 cellar: :any,                 arm64_sonoma:   "956371a814a279005c8b801707b40d0d7dce699c481f0bcac0ceb8cf8932505e"
    sha256 cellar: :any,                 arm64_ventura:  "41b9fe3eebdd1080259efefd73a04754c9e0837ee15abb839123d41e53019499"
    sha256 cellar: :any,                 arm64_monterey: "ea8ac3b10dcebb0b96b1d6f1ae08b71be65186fa64c8c4e5b06b512092608b6d"
    sha256 cellar: :any,                 arm64_big_sur:  "4b63bdd901dfc329c9c6caf41a0bb370f5b459f21ec5b09366c364156c38bd06"
    sha256 cellar: :any,                 sonoma:         "c2a0fd325e308410db0936384e54896d02b00dbd1be5513de8345e95455dfc55"
    sha256 cellar: :any,                 ventura:        "9e1f443063d01b844c19e6bee2e38d70fe102c8a130378b13167105aa25ea4d5"
    sha256 cellar: :any,                 monterey:       "0d520f6d78a8f7cd971fbd36897cb9d442ee2da93c3701d724e8b4eb7195858f"
    sha256 cellar: :any,                 big_sur:        "73650301b811cdf4d5aaaab55961708ac3ccede6900f61222a3dcf94a0b9f4fe"
    sha256 cellar: :any,                 catalina:       "d7f6515e6a018fd9b9fb47d25610e62cef4f0953fa3c33c7fb3499d5ed0e3f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a6d298d08f8835795b6d9051626344d25e7f88725ed2b9a5a1b7a098f75438aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41b0f8cff7affaeb1f8df48a2f13e4ce0fda9ad886c73ec3ada492cd1c9e862c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libnova/julian_day.h>

      int main(void)
      {
        double JD;

        JD = ln_get_julian_from_sys();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnova", "-o", "test"
    system "./test"
  end
end
