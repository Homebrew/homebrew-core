class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.7.2.tar.bz2"
  sha256 "1cfa35e37aaabbe4792e9bb690468efefbfbf6b147d9c69d6f90d13c3092ea6c"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "48e179ebf398452e95cf2664973153f2f0f1f0d96690e1a65beefa0bac63277f"
    sha256 arm64_big_sur:  "07000e94eab9193f9306fa2fd097ad8910e937c5573e77360d53bd9f9db64e7c"
    sha256 monterey:       "279e4b31afc2771f59e2528dd795c2894732e786c07ecefc7cfc336e1ae6bed8"
    sha256 big_sur:        "7aee5576a2669a20c9c0421a5afdce633130aeebe3f610c646f15dd5fe299f34"
    sha256 catalina:       "d7dede7503227acecc6992b96b2c14472d704cf6a7c71d81efd9a8ea710ba089"
    sha256 mojave:         "fc897d1f8a8619461f8e50cb7fe20682cd3021393cac7fd3ec94fa4c3c3ee7fd"
    sha256 x86_64_linux:   "035f49996ae8031ba4531113482e789feb51abeb8877eb8c0681ea615ff8cd93"
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
