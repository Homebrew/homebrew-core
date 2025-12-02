class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.12.tar.gz"
  sha256 "220fbcf54b6e4d8dc40076ff4ab87954358019982490b33c7802190b62d89ce1"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "c89e0707ee679b4e6a5c5995461ac1e4d469b13b997ca528aed7601c3a4a2cb2"
    sha256 arm64_sequoia: "57ccd55767fd6ffc7d32940d1c59d59b42c82abff4abf795b4ca0df489da42f1"
    sha256 arm64_sonoma:  "aa0440afde483eec625c716e22f9d4b883b5993a9b2bcf539f1199387127a46c"
    sha256 arm64_ventura: "693416ac252f1635f9324ff123620482daa904debeb4297f69bc61b3e72176ff"
    sha256 sonoma:        "5d916769cf91a23fff62dbd1b9c791beeca44504e72907511b352f8f758dae4b"
    sha256 ventura:       "f1c6b7e52cfa19f8aa99cfd86dfa56597a719850244e4162905a385970862c54"
    sha256 arm64_linux:   "b18a0e0f7eff31b9ba6de1352133bf25b7645ca83d0fb937afa29c6031607a37"
    sha256 x86_64_linux:  "7e74d0c1204bf8bb3d9cc9984a0efce1cba85284505076a0508f29e190b7bb2b"
  end

  depends_on "pkgconf" => :build
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

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lX11", "-o", "test", "-I#{include}"
    system "./test"
  end
end
