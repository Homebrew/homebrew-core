class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libX11-1.8.14.tar.gz"
  sha256 "ebb8a58549ddde50aa2e742b3b256557f451053d173be8dbfc2e8ac078eee1d6"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "f16e804d426ea8b43df43c0a6207a106a342b35275e5c061ec8f89ad032140a1"
    sha256 arm64_tahoe:       "38fbafb4e0ff48cf924f110e1e11442df06091298dfce50b82866dcb7355cb1b"
    sha256 arm64_sequoia:     "fdc6503c67fb5814bf7de665629b8dbda0807eda7b07d3c2668807768b4ae103"
    sha256 arm64_linux:       "4fee0a56737a4d2f402edaa3e4b762c45766790c2903899a9a062f3e081b8d19"
    sha256 x86_64_linux:      "f45a8c9534486b9537d4be52ac32b0742f72d7faf485b99e0f089f07803be224"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "libxcb"
  depends_on "xorgproto"

  deny_network_access!

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
      --enable-xthreads
      --enable-specs=no
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <X11/Xlib.h>
      #include <locale.h>
      #include <stdio.h>

      int main() {
        setlocale(LC_ALL, "");
        printf("XSupportsLocale=%d", XSupportsLocale());

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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lX11", "-o", "test", "-I#{include}"
    assert_match "XSupportsLocale=1", shell_output("./test")
  end
end
