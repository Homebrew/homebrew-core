class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.7.tar.gz"
  sha256 "793ebebf569f12c864b77401798d38814b51790fce206e01a431e5feb982e20b"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "0894f5a7c09c10a989dc12b792cff2f1d1ae7d1d49f7c8c559e79b9d911ca998"
    sha256 arm64_ventura:  "1b8f10d203c34bae4a94f89ce2d491374a6820c5cca87e1504bf92d2ce43d49f"
    sha256 arm64_monterey: "975cbce1a6e7a0fe341781e70ceea78a1dff3e18ccb5d4277d99443c887c13f2"
    sha256 sonoma:         "be011cbeeade38719d0d43d00d40176087c2182cd53086e30dcb263eea4ec62f"
    sha256 ventura:        "60a6a9eff38b882a536a124a18216788fdb20f885e65d011129e57b92eecaec9"
    sha256 monterey:       "7f5eae59e701671a0ba8704ebc2cfa9f3087d8d085f22f69897f44ff8694cf62"
    sha256 x86_64_linux:   "0a5c1964c4e0293561b77353ab916b7869eff803f3c664a01f05d2ced1e67f1f"
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
