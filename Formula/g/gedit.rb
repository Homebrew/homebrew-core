class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://download.gnome.org/sources/gedit/48/gedit-48.1.tar.xz"
  sha256 "971e7ac26bc0a3a3ded27a7563772415687db0e5a092b4547e5b10a55858b30a"
  license "GPL-2.0-or-later"
  revision 1

  # gedit doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/gedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "0323b81935c3fc2d9872740e65cc9fd088430a153664a784b78713f06e3fc532"
    sha256 arm64_sequoia: "ec5719d26fed80776a4fb1777662122d2e7b434d1492fada3a8cdaacf748e6ef"
    sha256 arm64_sonoma:  "dd25c3dad8b9a1fe25f124f51124753017104adadc18f149ea773c7ba6133eb2"
    sha256 arm64_ventura: "ea63034c7a611a56e45bbc86465ac8c32eced7f5373999b6a83c7c34b960771f"
    sha256 sonoma:        "a47a58a07db6e69d0571b0b8a37560ae46d484a3bd9e8a30961c8aea09ec3b62"
    sha256 ventura:       "4d0d3119fe0a87a1de634fba76cabd8b5ae905ddc9846d3d148162eb12bdf3f3"
    sha256 arm64_linux:   "eec17f8ae2606d4c7ba933d2ac5d0049e2b2c8d63890140c5b7d23cada3e1e26"
    sha256 x86_64_linux:  "9c42111b4fa4da254c01d5884a5bae04041efa34d557f99691a142bff1479a5c"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gfls"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libpeas@1"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "gtk-mac-integration"
  end

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
    (testpath/"test.c").write <<~C
      #include <gedit/gedit-debug.h>

      int main(int argc, char *argv[]) {
        gedit_debug_init();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
