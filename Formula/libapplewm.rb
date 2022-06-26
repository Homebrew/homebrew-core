class Libapplewm < Formula
  desc "Xlib-based library for the Apple-WM extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "054032d8ea48004ed41b659815c0d934cb386280d7651ea304118395bafdc360"
    sha256 cellar: :any, arm64_big_sur:  "0356059f0accd7c74e4082d944d1404c5b36457d8b3ecc7bee80faeb7523b16b"
    sha256 cellar: :any, monterey:       "05a90d77f0c0803ee859872051157b3070f97b8ab7999d7f4c7ed02e1df57a24"
    sha256 cellar: :any, big_sur:        "33eb76e5d25de65e9970f5cb9795c8933090ce9eb4e2c9574d589c0b222dde39"
    sha256 cellar: :any, catalina:       "c3e392ce25599cfe0929f1cd14a24a4d512697c952f15dea0533c2dbb8755b23"
  end

  depends_on "pkg-config" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on :macos

  def install
    # Use -iframeworkwithsysroot rather than -F to pick up
    # system headers from the SDK rather than the live filesystem
    # https://gitlab.freedesktop.org/xorg/lib/libapplewm/-/commit/be972ebc3a97292e7d2b2350eff55ae12df99a42
    # TODO: Remove in the next release
    inreplace "src/Makefile.in", "-F", "-iframeworkwithsysroot "
    system "./configure", *std_configure_args, "--with-sysroot=#{MacOS.sdk_path}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/Xlib.h>
      #include <X11/extensions/applewm.h>
      #include <stdio.h>

      int main(void) {
        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL) {
          fprintf(stderr, "Unable to connect to display\\n");
          return 0;
        }

        XAppleWMSetFrontProcess(disp);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-L#{lib}", "-L#{Formula["libx11"].lib}",
      "-lX11", "-lAppleWM"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
