class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.10.tar.gz"
  sha256 "b7a1a90d881bb7b94df5cf31509e6b03f15c0972d3ac25ab0441f5fbc789650f"
  license "MIT"

  bottle do
    sha256 arm64_sequoia:  "c6f87c76459254b07fff761beac4092db78f520edc26b0fb489b5f9c6b767fa5"
    sha256 arm64_sonoma:   "5467d41501260e483586e9b05ed3137393f7faf7d49901c31bbeb0b25bd7caf5"
    sha256 arm64_ventura:  "144c9ca0fd07301773ec072adf505ba73a2c2561ad211cc7067b98b92034cb72"
    sha256 arm64_monterey: "f323202b5650d3114a7215bcf8017cc144140c49baf122501a8bc31d3b24bfa7"
    sha256 sonoma:         "ae4c27d75532011351ec195f21e63640a1df4393a66985bf5078df0a446fee73"
    sha256 ventura:        "220bce8f5d80d6894f7e25d02c32f1a3ec1d4d3f0ecf5f4ba619de7a80986a1a"
    sha256 monterey:       "0989016905547b3899a956bbb45a95b6dc50fffab2af5afd6685486bea03281f"
    sha256 x86_64_linux:   "12f965d5b1d09327b0040b9e0f385ca5d4db9ceb29f8c89e6fcbe6e98ecf71c6"
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
