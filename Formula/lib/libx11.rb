class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/lib/libX11-1.8.13.tar.gz"
  sha256 "acf0e7cd7541110e6330ecb539441a2d53061f386ec7be6906dfde0de2598470"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "0e2fe58e32bcc6a65fd01f653b9f6986c38723f295a60fdf3648111d774dc3ee"
    sha256 arm64_tahoe:       "eea875959b2cd7b129fe9459e1771141b9215f3452e671996434f664fe96e193"
    sha256 arm64_sequoia:     "af553e32325d1817b6526682e3ca5d73e354145df362790eb9fc9f231e6d8a35"
    sha256 arm64_linux:       "93f44b03e57d3d6b02eb9a5155a969b974b0b4040d8de2f0a88d25e34f5eaff1"
    sha256 x86_64_linux:      "bf17b051a14a369ee1aa3e3566338aafe21fedae9735f6b178197e871d042ac2"
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
      --enable-loadable-i18n
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lX11", "-o", "test", "-I#{include}"
    system "./test"
  end
end
