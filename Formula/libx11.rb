class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.7.5.tar.gz"
  sha256 "78992abcd2bfdebe657699203ad8914e7ae77025175460e04a1045387192a978"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "83dffe0e016e562bff0348a889be9aa5f073a248574b160ca9a5bbb898303749"
    sha256 arm64_big_sur:  "043f7cc424992bff6091f9703fd871899cb418a78d8037f90ca95abed8178d92"
    sha256 monterey:       "229810a6d7e1c1c1bb6660a2f6fc14283e3f8788163494f8c8206bdf3517aa27"
    sha256 big_sur:        "3f8f45380f6c356d12209c7de7b145a4715a79d79713e8364ec04ab5ab187cae"
    sha256 catalina:       "61f5bff3afeaae4aed525b31e2648fe95bf73c48cbf4c4aa65cc2706221ba694"
    sha256 x86_64_linux:   "f58969cf7aaf3ccdf3d06f6100b9d7efc42dd31b34b0999dcb38d71d638b310d"
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
