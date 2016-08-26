class Gtkx3 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "http://gtk.org/"
  url "https://download.gnome.org/sources/gtk+/3.20/gtk+-3.20.6.tar.xz"
  sha256 "3f8016563a96b1cfef4ac9e795647f6316deb2978ff939b19e4e4f8f936fa4b2"

  bottle do
    rebuild 1
    sha256 "613732062b8f8bcb43af6bc468e3b764c84b551bc6cd282f11502a650c737d67" => :el_capitan
    sha256 "cd8ee7e7a4460c8a55eb59aed794104209109541de443d83573f76a31ac8f455" => :yosemite
    sha256 "5e4d2544955f3783316804c7962e7f30fece7a1a9cd92ea5a2b595c204ce55ac" => :mavericks
  end

  option :universal
  option "with-quartz-relocation", "Build with quartz relocation support"

  depends_on "pkg-config" => :build
  depends_on "gdk-pixbuf"
  depends_on "atk"
  depends_on "gobject-introspection"
  depends_on "libepoxy"
  depends_on "pango"
  depends_on "glib"
  depends_on "hicolor-icon-theme"
  depends_on "gsettings-desktop-schemas" => :recommended
  depends_on "jasper" => :optional

  # Fixes detection of CUPS 2.x by the configure script
  # https://bugzilla.gnome.org/show_bug.cgi?id=767766
  # Merged upstream, should be in the next release.
  if MacOS.version >= :sierra
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/a1fccbb34751eabe52366b8bb68bcf56ae74517c/gtk%2B3/cups.patch"
      sha256 "c1e8eb7ebf0fc75365bf76f1db11ac4ff347b9a568529b3051adaecca0573c81"
    end
  end

  def install
    ENV.universal_binary if build.universal?

    args = %W[
      --enable-debug=minimal
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --enable-introspection=yes
      --disable-schemas-compile
      --enable-quartz-backend
      --disable-x11-backend
    ]

    args << "--enable-quartz-relocation" if build.with?("quartz-relocation")

    # TODO: Remove when it fails. See https://git.gnome.org/browse/gtk+/commit/?id=74bd3f3810133d44f333aa5f8d02ae3de19a6834
    inreplace "gdk/quartz/gdkeventloop-quartz.c", "g_string_appendi", "g_string_append"

    system "./configure", *args
    # necessary to avoid gtk-update-icon-cache not being found during make install
    bin.mkpath
    ENV.prepend_path "PATH", bin
    system "make", "install"
    # Prevent a conflict between this and Gtk+2
    mv bin/"gtk-update-icon-cache", bin/"gtk3-update-icon-cache"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libepoxy = Formula["libepoxy"]
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
      -I#{glib.opt_include}/gio-unix-2.0/
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}
      -I#{include}/gtk-3.0
      -I#{libepoxy.opt_include}
      -I#{libpng.opt_include}/libpng16
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lcairo-gobject
      -lgdk-3
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-3
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
