class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.8.tar.gz"
  sha256 "26997a2bc48c03df7d670f8a4ee961d1d6b039bf947475e5fec6b7635b4efe72"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "1e6382a60b8f7bba273ef18e3c921d62c7194d2c47c61d6e4788435998aa6991"
    sha256 arm64_ventura:  "2c8b93b65cfc782eb63cda2429b8b870966cbb26e0b6e24df6aa1d61bdc4a441"
    sha256 arm64_monterey: "f32ce3c7f827ac39747d99042f29741cbd1421b39c092d9932eb03a17bfbfffb"
    sha256 sonoma:         "6cfbdd50b67be869125e066d55c0e39e5becf2f04a4cb610ad3d50435452048a"
    sha256 ventura:        "5166b06da3dd877141262e74bf27f1c1e3ed20dafa83564923e543ccf4f51af4"
    sha256 monterey:       "1508f754f7bc89d84218dc051d5cb92bd90b54063fe0eb753b2a5062862e980a"
    sha256 x86_64_linux:   "41934b03c069272eee229ffc651e867d7891e30ea53dab8a793e3ba2cafd64e7"
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
