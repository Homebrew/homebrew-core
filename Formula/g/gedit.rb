class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/46/gedit-46.2.tar.xz"
  sha256 "c0866412bad147ebace2d282ffcbb5a0e9a304b20fd55640bee21c81e6d501ef"
  license "GPL-2.0-or-later"

  # gedit doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/gedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "777d2f0921fa04711b03b411ca7c694c49cf2e1d83f2adbaa4c666a2f6b066d6"
    sha256 arm64_ventura:  "9782b95eeb5018630fdf4eb107c6de00b163e9f764926451fe9f5b61caeae54e"
    sha256 arm64_monterey: "a901fbafe0f26f5f15c7639590cfea0b8e507c8d9ac4cb45dc9522ee95a416f8"
    sha256 sonoma:         "3d9eb8f9c8510c0c1ef5123053834f9b69fd7feed60fff48d3b660e4746cf59b"
    sha256 ventura:        "4110ca2fc7ee3eeff7fac46ad5c4af84e805ca5e559f6a4f393340ed103e3dfa"
    sha256 monterey:       "95fc3cbec4956c99dd475fd985f63b30fcaf1a0cf0952de91e0b641d45091a97"
    sha256 x86_64_linux:   "3784d5b0bce3a017dbe55447af1dee3a2b335f4dfbd0a7340a98c2c511eea35a"
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
  depends_on "at-spi2-core"
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
  depends_on "libpeas@1"
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
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libpeas@1"].opt_lib/"pkgconfig"

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
