class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.6.tar.gz"
  sha256 "5ff0d26c94d82ebb94a944b9f1f55cd01b9713fd461fe93f62f3527ce14ad94e"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "deac131d507c6f21ee96567f070a61426d429232161f36077382b381b884abca"
    sha256 arm64_ventura:  "12634191390f2feaad802e2c98dbee1274f688d1348ba7319462340defe2d07d"
    sha256 arm64_monterey: "4899cff98c20b47226c7817b898132f9c9c68da2cb4b7b5176efc442a0030bde"
    sha256 arm64_big_sur:  "5411fb6d4c702ee5413af825418e6157ca45f3d855710bcfc644bb0476cd207a"
    sha256 sonoma:         "6e1cb8e6d2c5fe3bd9c10911c581188dcb26a0dc40c2402f52d3e72e8b4197ca"
    sha256 ventura:        "da763d80a33ebfbac8064a9528d9e7ccde2a4527dc48f80a003166c7dd4021bf"
    sha256 monterey:       "2c4826ba65ab97f4d201a5624cc675fbefd563a831fab866c8966b32c89f3e17"
    sha256 big_sur:        "e321aa3d735de0a2f4f7b2d5c6dde6184cc8590c348c3d1dd773fac892db6ecd"
    sha256 x86_64_linux:   "6b4be1e7e026639d80f2541fc72cf0caf8b15670efdab3abc1cd4b291f486910"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "libxcb"
  depends_on "xorgproto"

  def install
    ENV.delete "LC_ALL"
    ENV["LC_CTYPE"] = "C"
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-loadable-i18n
      --enable-xthreads
      --enable-specs=no
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <X11/Xlib.h>
      #include <stdio.h>
      int main() {
        Display* disp = XOpenDisplay(NULL);
        if (disp == NULL)
        {
          fprintf(stderr, "Unable to connect to display\\n");
          return 0;
        }

        int screen_num = DefaultScreen(disp);
        unsigned long background = BlackPixel(disp, screen_num);
        unsigned long border = WhitePixel(disp, screen_num);
        int width = 60, height = 40;
        Window win = XCreateSimpleWindow(disp, DefaultRootWindow(disp), 0, 0, width, height, 2, border, background);
        XSelectInput(disp, win, ButtonPressMask|StructureNotifyMask);
        XMapWindow(disp, win); // display blank window

        XGCValues values;
        values.foreground = WhitePixel(disp, screen_num);
        values.line_width = 1;
        values.line_style = LineSolid;
        GC pen = XCreateGC(disp, win, GCForeground|GCLineWidth|GCLineStyle, &values);
        // draw two diagonal lines
        XDrawLine(disp, win, pen, 0, 0, width, height);
        XDrawLine(disp, win, pen, width, 0, 0, height);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lX11", "-o", "test", "-I#{include}"
    system "./test"
  end
end
