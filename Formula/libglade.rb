class Libglade < Formula
  desc "RAD tool to help build GTK+ interfaces"
  homepage "https://glade.gnome.org"
  url "https://download.gnome.org/sources/libglade/2.6/libglade-2.6.4.tar.gz"
  sha256 "c41d189b68457976069073e48d6c14c183075d8b1d8077cb6dfb8b7c5097add3"
  revision 4

  bottle do
    rebuild 1
    sha256 arm64_monterey: "72596bd26b4e2fe8f08f3355afedccd2c8f9c9d6631794317c635e43d784fe2e"
    sha256 arm64_big_sur:  "d4590501ed823f6ba28905f2a7ab3e5d64b6497393b11829fb753c7ed56cc1d3"
    sha256 monterey:       "339fbb07749127c633652418e75148dbaed80c073f24aaee0982cd9ff2cc5ff0"
    sha256 big_sur:        "7408ed79b9c5c118628b566cda02c6fec57cb8cbdbad4db83759f41324d5171f"
    sha256 catalina:       "f87fe8b63946d78fd43586ef25fbd108d9f81fda2089a66f40cbdc0216601f8e"
    sha256 mojave:         "3fdb8055e888e22f7054432b185aad35a20c0d48b3c07c97429cab2b7a0bd3cc"
    sha256 high_sierra:    "fd198334f49180de53d5bde9406e17aa4e3051ee5c421defdab9dbb0f3a1e681"
    sha256 sierra:         "019f499d6ca86f279d5bfec74bf71ffe11a89bb6bc70f6901b7074e14885132c"
    sha256 x86_64_linux:   "bcdaaabe9019e832d451948a90c49f999d28b576610d4c46ea6bf2594b1fbc66"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "libxml2"

  def install
    ENV.append "LDFLAGS", "-lgmodule-2.0"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<~EOS
      #include <glade/glade.h>

      int main(int argc, char *argv[]) {
        glade_init();
        return 0;
      }
    EOS
    ENV.libxml2
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    gtkx = Formula["gtk+"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx.opt_include}/gtk-2.0
      -I#{gtkx.opt_lib}/gtk-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libglade-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglade-2.0
      -lglib-2.0
      -lgobject-2.0
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    if OS.mac?
      flags << "-lgdk-quartz-2.0"
      flags << "-lgtk-quartz-2.0"
      flags << "-lintl"
    else
      flags << "-lgdk-x11-2.0"
      flags << "-lgtk-x11-2.0"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
