class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.22/glade-3.22.0.tar.xz"
  sha256 "6c66843a5883bbeb0dde4fdc0d19f6572dd23671aa2c3fdab4e4eb2889bff3c8"

  bottle do
    sha256 "4efce43d4bc49db1e3ca919429b3ee466bb686579b5a58c83a0919c7df9f9281" => :high_sierra
    sha256 "7460d24243002f19c6173b9bfd71a59eba0636cfb987b126cc58145dfc191767" => :sierra
    sha256 "22175453f205adf6facdadbe55589e6ff4a2b34a4df77a7729e67d0e157c0cc8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "libxml2"
  depends_on "adwaita-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-gladeui",
                          "--enable-introspection"
    # objective-c is needed for glade-registration.c. unfortunately build fails if -x objective-c is added to global CFLAGS.
    # Bugreport Upstream: https://bugzilla.gnome.org/show_bug.cgi?id=768032
    inreplace "src/Makefile", "-c -o glade-glade-registration.o", "-x objective-c -c -o glade-glade-registration.o"

    system "make" # separate steps required
    system "make", "install"
  end

  test do
    # executable test (GUI)
    system "#{bin}/glade", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gladeui/glade.h>

      int main(int argc, char *argv[]) {
        gboolean glade_util_have_devhelp();
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
    gtkx3 = Formula["gtk+3"]
    harfbuzz = Formula["harfbuzz"]
    libepoxy = Formula["libepoxy"]
    libpng = Formula["libpng"]
    pango = Formula["pango"]
    pcre = Formula["pcre"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{gtkx3.opt_include}/gtk-3.0
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/libgladeui-2.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pcre.opt_include}
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{gtkx3.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lgladeui-2
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
