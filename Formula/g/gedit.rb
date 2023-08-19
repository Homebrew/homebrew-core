class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/46/gedit-46.1.tar.xz"
  sha256 "a1a6e37f041765dff7227a1f5578b6f49faaf016b1e17e869caf5bfb94c6aa4e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "c5c423f03f3223640738588e8b039ffba1a7aa693ee624c3351faa5befeee5e4"
    sha256 arm64_monterey: "94eb96a3893d9ff2594a62d0121ee2e7da81c089612fab86fbb0889b2a3857c9"
    sha256 arm64_big_sur:  "4c9bd81c2ac45b00625beab8471105e7e8c1b861f8749a30e1a7c3033697a7e2"
    sha256 ventura:        "0e3029e4939dabcce383c8a3d69dee70863c2508d6af010da83e4e61af717132"
    sha256 monterey:       "f3c17e4bfcf524a88662f4adab87a00b4b9ba7a5802623f7261a523dbd76eb28"
    sha256 big_sur:        "aefd5b227129370ddb1d90bc92c6df4908980984fdec991a2f461edb6dbccb4d"
    sha256 x86_64_linux:   "ccb491551263d3e43dc064c02141b0095ebf615e78374445f59df7a2eecd8a3e"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libpeas"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pango"
  depends_on "tepl"

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/gedit" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?

    # main executable test
    system bin/"gedit", "--version"
    # API test
    (testpath/"test.c").write <<~EOS
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
