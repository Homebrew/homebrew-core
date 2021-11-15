class Libxcomposite < Formula
  desc "X.Org: Client library for the Composite extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcomposite-0.4.5.tar.bz2"
  sha256 "b3218a2c15bab8035d16810df5b8251ffc7132ff3aa70651a1fba0bfe9634e8f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7df5a19de82fe972923b97a102b2a04d0bdad40e9e540c7c534d1658b6c12ad6"
    sha256 cellar: :any,                 arm64_big_sur:  "4e8a37722a518d3478921c8577275ba351f3e997dbdd87daad6b13960ec3d4cd"
    sha256 cellar: :any,                 monterey:       "e1bcd6254b14d2df2e87aaf61329d00aa142d9b90fef82336ce005ee0c245c9a"
    sha256 cellar: :any,                 big_sur:        "19c39d055ed08a40db7d3e4514e21b16a73e6148317813a8f64ca85015a59dce"
    sha256 cellar: :any,                 catalina:       "3b8b0780e6c95393d9a6d56739ecc501b183d462009544c45d89293850c2ccf6"
    sha256 cellar: :any,                 mojave:         "5332e3ec89bac3372540513a9b54b3ba1d5f4bbe0dfe233d8297a4fbc6168d98"
    sha256 cellar: :any,                 high_sierra:    "4571cc99283062d9f242fcad7bbabb32ea687974723eaa0289639d018393ff61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f4011133b01fca5b78767e5c0e6b32c5de1121a31d9e58c596d0fabeda1e14"
  end

  depends_on "pkg-config" => :build
  depends_on "libxfixes"
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
      #include "X11/extensions/Xcomposite.h"

      int main(int argc, char* argv[]) {
        Display *d = NULL;
        int s = DefaultScreen(d);
        Window root = RootWindow(d, s);
        XCompositeReleaseOverlayWindow(d, s);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXcomposite"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
