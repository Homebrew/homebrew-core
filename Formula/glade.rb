class Glade < Formula
  desc "RAD tool for the GTK+ and GNOME environment"
  homepage "https://glade.gnome.org/"
  url "https://download.gnome.org/sources/glade/3.38/glade-3.38.2.tar.xz"
  sha256 "98fc87647d88505c97dd2f30f2db2d3e9527515b3af11694787d62a8d28fbab7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "2a55e22c571d0d158c1b66bf18c35c44aeaed0694d139f13c48f5a6642b4785b"
    sha256 big_sur:       "0fb77b21e6176c6690410a76d843f4582c1ef833e54ce5efa620bfce514e7af7"
    sha256 catalina:      "e5c239c3d05350ff8a8710ce6beecf7fd22461336e77d55febb338b6a1456a61"
    sha256 mojave:        "0b641d56f385a798fafe8fe424191de83207dea5b0edcf9d06c8b8b03ad0c68f"
    sha256 x86_64_linux:  "1ab1f368edebbb88fd763659089ffa8f987f2416583f3f59fb732300088b4f8e"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
