class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.7.5.tar.gz"
  sha256 "78992abcd2bfdebe657699203ad8914e7ae77025175460e04a1045387192a978"
  license "MIT"

  bottle do
    sha256 arm64_monterey: "bfbdc0d5131a5de5af488a3bca4d21bf0b234fdeb5e815d27118185797dfb504"
    sha256 arm64_big_sur:  "d5844f2f5eb76760b8018d99f7260ad1288e464cba8fdadce290d51087923ccf"
    sha256 monterey:       "bdbae40d452075838a74df3b078aee8a64bfa399fe1df65a3897995bf193dbf0"
    sha256 big_sur:        "9c6cae8533144284adc333fd7f7d7718fcdcaff9f37a0979b0b6e358b661134c"
    sha256 catalina:       "9ac01c5ba3fe93243188303cdd652cbe0c7f4607b412c2596f54eb4f92ad5453"
    sha256 x86_64_linux:   "0ecf5a4ebc6f6e2153dd4883b3c24565f6db2d48667a2d3a71ee19ccd8d55dcb"
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
