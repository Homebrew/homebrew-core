class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://gedit-technology.github.io/apps/gedit/"
  url "https://download.gnome.org/sources/gedit/48/gedit-48.0.tar.xz"
  sha256 "fe0fef9b7b0799120db86ae893a060036a13445352ded9169bab28d38acf0e80"
  license "GPL-2.0-or-later"

  # gedit doesn't seem to follow the typical GNOME version scheme, so we
  # provide a regex to disable the `Gnome` strategy's version filtering.
  livecheck do
    url :stable
    regex(/gedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "83fe0bda6dccd626c19648210c10c93ef704c741e3fdc4b38c290aa383492286"
    sha256 arm64_sonoma:  "065ab3ebd2816a03034cf4f12503c38e24fa75aa27223c7f68567c71e1e1a44b"
    sha256 arm64_ventura: "f50188ba824bdaad251d67bca1a0afa68d373efd4d0708a24f1c382e6c1a1c54"
    sha256 sonoma:        "f1036b5616817ac915b66e5b975b95348d6616205451341316b7dae21dca3275"
    sha256 ventura:       "4ba6a406eabef6af60d36da98d699612f061bad2b212f188edbb0cf11443e41f"
    sha256 x86_64_linux:  "a67cc884fd2bfba8121e786bc14181c046941f9c2efc8557de8a18205253f49a"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

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
  depends_on "libxml2"
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

    flags = shell_output("pkg-config --cflags --libs gedit").chomp.split
    flags << "-Wl,-rpath,#{lib}/gedit" if OS.linux?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
