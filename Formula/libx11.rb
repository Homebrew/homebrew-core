class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.1.tar.gz"
  sha256 "d52f0a7c02a45449f37b0831d99ff936d92eb4ce8b4c97dc17a63cea79ce5a76"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "dc03a6058d4ac7ae5c58f30e3cc78a056d26417388190f75947e6b58dc306160"
    sha256 arm64_big_sur:  "fe550c503a924fd78a9865793706a8e208752b890713a6699282630b28d7ad50"
    sha256 monterey:       "cf5034cc7c677f80d4301bff99b6135df077fdd0a7933a1054e5f505152da21b"
    sha256 big_sur:        "69397e1eac69a76cc58f58e7e5764fa2eccaff9fbd891f42a7da0dee72b75d8c"
    sha256 catalina:       "898dd6a72382f37b6508762d3a377db445be7f254d64a5140a8958b189f27ce9"
    sha256 x86_64_linux:   "1a0f30a63d5cd9f212f6999156baf0503dcc85c0c9b6ce4fe8a9116727a77a84"
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
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
      --enable-loadable-i18n
      --enable-xthreads
      --enable-specs=no
    ]

    system "./configure", *args
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
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
