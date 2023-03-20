class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.4.tar.gz"
  sha256 "efd3a3a43c1f177edc2c205bedb0719b6648203595e54c0b83a32576aeaca7cd"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "e6df4fc6bb84dd64a2f2c68d474c415de2a0fa0aac85ff4e650a56c0d739463e"
    sha256 arm64_monterey: "5da752047f0745a2628343aa2f313f4544b13d0643ff796ae079fcc4d3203a63"
    sha256 arm64_big_sur:  "91e5e9c3b7becc85dd159b7998b35a727ae2317ddc69791e5d4f4e0de9724fe2"
    sha256 ventura:        "44e791ead3f697bb6fc7bc368b202bf0b72370f65fbef8a35ae7f97bb4057e00"
    sha256 monterey:       "f8dcffa69f82057a0c93cd570fa0f14a06c0a13b0380cac5b616536f482c67a2"
    sha256 big_sur:        "858c07647c7acb5fb6a4693b1511968bb933f98a1f58a160a446214df243e177"
    sha256 x86_64_linux:   "5b47168c3429621d90970b2eb620b20a2dee315655b484b5a914241d9d562740"
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
