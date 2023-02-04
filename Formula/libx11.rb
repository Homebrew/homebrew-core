class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.4.tar.gz"
  sha256 "efd3a3a43c1f177edc2c205bedb0719b6648203595e54c0b83a32576aeaca7cd"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "7371880b0132555d489372a030da8d7729f5e9d616cfe7bf85eaf96582e009dc"
    sha256 arm64_monterey: "5bf92846af5d31c81a0f3fd3240ab4f6603add8a16f917ef49ff076e36e109c4"
    sha256 arm64_big_sur:  "afe243dc0a4dc9060560700af09be64b3254c9320f7c244121d4ac89bd51e973"
    sha256 ventura:        "9e59b6693cf51b31b6709f4fb536adedb82544829012f057179c0624136c3585"
    sha256 monterey:       "4077385db58902e2ca2adfa41c461ffaf352a38dbd10b3765b82b4d9d7f913dc"
    sha256 big_sur:        "658c411a8bb76ed0c97d3e445e01eff9e54a6cbdbb5b8fbdc495d801fea58869"
    sha256 x86_64_linux:   "3c69dcd99677609205c21fdaab84931471b7e8ce3a7242dfecf58099a566eab5"
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
