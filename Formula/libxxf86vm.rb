class Libxxf86vm < Formula
  desc "X.Org: XFree86-VidMode X extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXxf86vm-1.1.5.tar.gz"
  sha256 "f3f1c29fef8accb0adbd854900c03c6c42f1804f2bc1e4f3ad7b2e1f3b878128"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5d9a140e35a74386e87ff2f65d9fb700388c023caab750e40474a1be9b7d5037"
    sha256 cellar: :any,                 arm64_monterey: "131201608ae04d81b2b40a3a97f88b9c187cd06f283b231032705f6b254acec7"
    sha256 cellar: :any,                 arm64_big_sur:  "e3022d9b03e5d97db357336d1ea2dbc273ea491664fc06639fcb957c3706d708"
    sha256 cellar: :any,                 ventura:        "3c2d5394c0ccec2bec8a03ffd8f51f8d3e9faf949c360986d9ec97afc24ff87c"
    sha256 cellar: :any,                 monterey:       "09f1d1153b1253ad201168030020a59325387b5a31be5010d04005284693da99"
    sha256 cellar: :any,                 big_sur:        "be95491ec6ca607b8794b7fd227de7654f6b016156410c61e88b1b956313d2a8"
    sha256 cellar: :any,                 catalina:       "a12f91c2845e9e56637f40eb6e54bc7a8fbed35e276dd3b1a6cce92adda78504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db08eb34714521835fe1a5abf153e1b551329230b951ce7ef9bb2c6ca29be893"
  end

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/extensions/xf86vmode.h"

      int main(int argc, char* argv[]) {
        XF86VidModeModeInfo mode;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
