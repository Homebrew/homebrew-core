class Gedit < Formula
  desc "GNOME text editor"
  homepage "https://wiki.gnome.org/Apps/Gedit"
  url "https://download.gnome.org/sources/gedit/44/gedit-44.2.tar.xz"
  sha256 "3bbb1b3775d4c277daf54aaab44b0eb83a4eb1f09f0391800041c9e56893ec11"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "de832d8fb0b0248d19e07c69ed39adffd59968fd48cd0c14033a85387713ee1a"
    sha256 arm64_monterey: "aad806aa20f386b697e27d02e842a5aa5fec007a30d4067f84be1f43595e4357"
    sha256 arm64_big_sur:  "cd69203dfe0a8bed0f00542d2ddb9286a645424b5022cb2ecc4729c96dc97e7f"
    sha256 ventura:        "6b4d031aaeb367eb24c7adbea442dcbb3b9b29bc062bcc49dd7f00a06a66379a"
    sha256 monterey:       "e565dd03ea823cfd5cbfedf58aa5aca391d0821a57435f99d9915ef8706e6431"
    sha256 big_sur:        "4e230308e50adfccc7a6357a9f7c457b2145c31cc076c61b4434d87ac48c044b"
    sha256 x86_64_linux:   "8eb36b2f3a46162a5b17a9cc4466f68d2471cc27a3ce0cef27c139029b4bd283"
  end

  depends_on "docbook-xsl" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "adwaita-icon-theme"
  depends_on "amtk"
  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gsettings-desktop-schemas"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
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
