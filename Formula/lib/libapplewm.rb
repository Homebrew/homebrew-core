class Libapplewm < Formula
  desc "Xlib-based library for the Apple-WM extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/lib/libAppleWM-1.4.1.tar.bz2"
  sha256 "5e5c85bcd81152b7bd33083135bfe2287636e707bba25f43ea09e1422c121d65"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "4b8eba3bb855a350470232642c48f34eb601408e1b7a4650bed5934bf0e6c6bc"
    sha256 cellar: :any, arm64_sequoia:  "9aed87eee9abadbc7e94ee746f6b54588d3eacd9fb455b2d94a96c4b7a19425e"
    sha256 cellar: :any, arm64_sonoma:   "a85cafdda17d42585277fa6d22fb7b7d71d030c9ec591d4cbcc528a32ef5410e"
    sha256 cellar: :any, arm64_ventura:  "5292c56db7842b7784fc2d8cb11ca61ea9cfc1ec4c8293c4faeeaf9a8b8de876"
    sha256 cellar: :any, arm64_monterey: "054032d8ea48004ed41b659815c0d934cb386280d7651ea304118395bafdc360"
    sha256 cellar: :any, arm64_big_sur:  "0356059f0accd7c74e4082d944d1404c5b36457d8b3ecc7bee80faeb7523b16b"
    sha256 cellar: :any, sonoma:         "beefb395695ff755d3d88c6ce1373f03954888d22a737d353059500673605d3d"
    sha256 cellar: :any, ventura:        "dff0dd7ef1cf645b88d606c7580c60294693c9ebe8a59ccfe477c66ab1765e37"
    sha256 cellar: :any, monterey:       "05a90d77f0c0803ee859872051157b3070f97b8ab7999d7f4c7ed02e1df57a24"
    sha256 cellar: :any, big_sur:        "33eb76e5d25de65e9970f5cb9795c8933090ce9eb4e2c9574d589c0b222dde39"
    sha256 cellar: :any, catalina:       "c3e392ce25599cfe0929f1cd14a24a4d512697c952f15dea0533c2dbb8755b23"
  end

  depends_on "pkgconf" => :build

  depends_on "libx11"
  depends_on "libxext"
  depends_on :macos

  def install
    # Use -iframeworkwithsysroot rather than -F to pick up
    # system headers from the SDK rather than the live filesystem
    # https://gitlab.freedesktop.org/xorg/lib/libapplewm/-/commit/be972ebc3a97292e7d2b2350eff55ae12df99a42
    # TODO: Remove in the next release
    inreplace "src/Makefile.in", "-F", "-iframeworkwithsysroot "
    system "./configure", "--with-sysroot=#{MacOS.sdk_path}", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-o", "test",
      "-I#{include}", "-L#{lib}", "-L#{Formula["libx11"].lib}",
      "-lX11", "-lAppleWM"
    system "./test"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
