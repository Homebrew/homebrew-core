class Libx11 < Formula
  desc "X.Org: Core X11 protocol client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libX11-1.8.9.tar.gz"
  sha256 "57ca5f07d263788ad661a86f4139412e8b699662e6b60c20f1f028c25a935e48"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "f9f790ea819b0549526b2200dc60f0faa26641639c6e83592ea507dd859c5162"
    sha256 arm64_ventura:  "19fa97fffd6ebd1b00afb572e6e645c237d12f896b6c8f0188bef4cb9de5a27f"
    sha256 arm64_monterey: "2c72d60940c554dbe21b6a9244104df58e559e2aa859ddf926733471c819e526"
    sha256 sonoma:         "e351920dd44b0b6df2eeb6f42f249ed0b0ed4e6f4a1fe96c9c943aa6605dc51c"
    sha256 ventura:        "84914fe802fccd05d3d1281e505a7ace64f7f5b3ad2690956d3bb732fca215a1"
    sha256 monterey:       "eb90de1b217dac58fbbff9265dc37b72341dc5f19418d3c13fc3041036dc7132"
    sha256 x86_64_linux:   "51b67b10bfcc472bdad4beeff32730e273f2f09caccf59d9fd72a658b4e78b93"
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
