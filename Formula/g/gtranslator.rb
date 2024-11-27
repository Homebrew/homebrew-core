class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/47/gtranslator-47.0.tar.xz"
  sha256 "76e1041c5efb0a88ba18764ea4588b4e1965fa50314e01a173fa3ea0150e1cd5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sequoia: "2e437ceeced7d637bf27767134cf2a2bc4450d8a4bbbe1f2c4e2d1366f132c5f"
    sha256 arm64_sonoma:  "7189d694adb46dcbb4d29903aa213ac3411954b3636d6e9b66734018457a837f"
    sha256 arm64_ventura: "4f1a1106b78f94f0ff7868db11fbce660706094e8516dd542ff0db74c04d86ec"
    sha256 sonoma:        "3e3325618a0b76ae70458fd864d466a95ea8847ad9c2da0c88948aa9574390ad"
    sha256 ventura:       "87be245fa245123cdf9e310b45da667f04ccf3e45404013918774bdfc8242b6f"
    sha256 x86_64_linux:  "6b63dcc4ddcaaa9e7fd4cc2e1edb3e7b82f5dd9edd704d5859bf9849ae088199"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libgda"
  depends_on "libsoup"
  depends_on "libspelling"
  depends_on "pango"

  uses_from_macos "libxml2"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gtranslator", "-h"
  end
end
