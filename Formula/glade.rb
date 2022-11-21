class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.40/glade-3.40.0.tar.xz"
  sha256 "31c9adaea849972ab9517b564e19ac19977ca97758b109edc3167008f53e3d9c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura:  "e9d58dc0453a314a7f65b58a05c26a60e1738129d46ab680809dd6ef8c1a940a"
    sha256 arm64_monterey: "3204eb2e65d9f7ee7bb01278866cd651584379e17bc3d9deb84fa3a9407e8c92"
    sha256 arm64_big_sur:  "90b87f046dff0347c67730ecc5e616477add043a717d3014fe6a5d585c0b87c8"
    sha256 ventura:        "9e7168e7ffcaaaadc81f3afa6206a77e00a76801f05d0a3a2b964770ca28caf9"
    sha256 monterey:       "29586d6ceb94728ae1dc1195e512a9a53da6a67c0efa52786f9860f768f43b73"
    sha256 big_sur:        "6ecb0865146c646602a1cfc885992a0d5f0e6b2a5b2eda31af6a6b05a3d25e2f"
    sha256 catalina:       "5268fbbba91775b3c1c12b3b7bdbe614c59ec60c16b72c20d7a4981d17dedbde"
    sha256 x86_64_linux:   "a00c2411a4290e3b5c38f49a7c69a74050e8997ae51a4f12ea11133c49eed945"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libxml2"

  uses_from_macos "libxslt" => :build

  on_macos do
    depends_on "gtk-mac-integration"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable icon-cache update
    ENV["DESTDIR"] = "/"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dintrospection=true", "-Dgladeui=true", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  def post_install
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # executable test (GUI)
    # fails in Linux CI with (glade:20337): Gtk-WARNING **: 21:45:31.876: cannot open display:
    system "#{bin}/glade", "--version" if OS.mac?
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
      -lpango-1.0
      -lpangocairo-1.0
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
