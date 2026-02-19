class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.13.tar.gz"
  sha256 "acf0e7cd7541110e6330ecb539441a2d53061f386ec7be6906dfde0de2598470"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "cddc8c50c6140f0f64724e4f7c508fe7d26676b24cf7ae2b2527bf884a07a5ea"
    sha256 arm64_sequoia: "1151df800309c229d23b41bdf27973d63619c423ce369164296af84b779482ce"
    sha256 arm64_sonoma:  "5d5325771c9ba385b0dec12f257cdd8baf43491dd79c55e79d1d600a6ae4d7e7"
    sha256 sonoma:        "32a48ce69d27f65034e12ecdf7053708dc88f6edc6c8c6c3b10ff471fbd056c5"
    sha256 arm64_linux:   "affc9d4a098b828773661c5dfecb32f3e32c2f07701ce11e6495c64f189f2aa3"
    sha256 x86_64_linux:  "d7b4f02a9f494cfe80106d3ec885233e06c1c34bbfdfff06a6548869d6844ab6"
  end

  depends_on "pkgconf" => :build
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
