class Libice < Formula
  desc "X.Org: Inter-Client Exchange Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libICE-1.0.10.tar.bz2"
  sha256 "6f86dce12cf4bcaf5c37dddd8b1b64ed2ddf1ef7b218f22b9942595fb747c348"
  license "MIT"

  bottle do
    cellar :any
    sha256 "19b9ff02ad9cd6cb6de1a0e1a69ab34add27f153b97487cac708b88cc1c3219a" => :big_sur
    sha256 "647f1d1e042e0ae014789da539e03f426f15d44ad66c707e74eb9b5b1290529a" => :arm64_big_sur
    sha256 "4c5c97814304360fdaeec959107e79e9fdb62ba151159ca55342944efec4bd82" => :catalina
    sha256 "d7249247483e6ee2787e66c7f887a7df52aedd5abd2558ae377b5d16e3b6275e" => :mojave
    sha256 "b5f1f14bc4fd8d18fd19b2552ddc898f53f573015de0706289de54c177b16eb4" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libx11"=> :test
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/ICE/ICEutil.h"

      int main(int argc, char* argv[]) {
        IceAuthFileEntry entry;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
