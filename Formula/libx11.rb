class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.7.3.1.tar.gz"
  sha256 "d9d2c45f89687cfc915a766aa91f01843ae97607baa1d1027fd208f8e014f71e"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "b4b79e9786251b9b7db58405d1beba611711808931fca05b26553d946e19af04"
    sha256 arm64_big_sur:  "0ca4bbf6322a52e55c7713a618e761f7c8b7a94c23786940f288d7298314b31e"
    sha256 monterey:       "da03deffc281abedfca2b12bdaebdd35ae7a504a4919813678751e391b3baae6"
    sha256 big_sur:        "a92d3ce37c518d5d029b35757e590c5a5aa203ebd32d8b0178f6f5a1ef199b16"
    sha256 catalina:       "4564b99ddedb32eb43591888da7daf02e37a2176d1ee45bd9d84e3430207ef06"
    sha256 x86_64_linux:   "eddbfe1550c74d81194f0ce4a69466825a1f1ac39e477d83e43789c0ffa34e4d"
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
