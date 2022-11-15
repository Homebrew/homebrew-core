class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.2.tar.gz"
  sha256 "f1bc56187bee0f830e1179ac5068ac93b78c51ace94eb27702ffb2efd116587b"
  license "MIT"

  bottle do
    sha256 arm64_ventura:  "996724436ae47440832ffe2caa9bec0d0f374f8885f83925453895fcfc80d8c2"
    sha256 arm64_monterey: "8d08dd29849612785db12fd469c707b136328bdfd4115d79b6afdfc1b13c9b38"
    sha256 arm64_big_sur:  "4448aa22e8118de5775caf8488b666a211b01f50085a418fbbbcbfed2d83e517"
    sha256 ventura:        "7d62f3b406f3ac7fad944ce6f2faaa5a496139a69f657ab467d118c4df9183db"
    sha256 monterey:       "cbaa4ea21135fa88c816263ea1d945e9b077be7c0fbe8ccca37ff924d9abb205"
    sha256 big_sur:        "c408a64f5e19800a746125e1ca3bec69440cf053cfd2d5e041469fbf66d16b4f"
    sha256 catalina:       "83b5c84a2f595ddb273b9eb9790109e542da3c21832df5cc6c90a1c328050389"
    sha256 x86_64_linux:   "d90e3f7a7ad612243113e10a31b0f71880f742d9af9fb656219a53270bfdbf67"
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
