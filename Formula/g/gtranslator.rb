class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/45/gtranslator-45.3.tar.xz"
  sha256 "3010204df5c7a5ae027f5a30b1544d6977d417f0e4bb9de297f0ad1a80331873"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "f7a83667fb2c292b47e3c25dc570f8da7b1893cb8f0525632b7557f9c3007392"
    sha256 arm64_ventura:  "457582c7749a84d92150f62ca6c7481b4a420f6646f5d14ec4d99d180da18a05"
    sha256 arm64_monterey: "13ccfd1b17f9a2d5f07f9f7504d3ab0b97d7babb8b7180f1fe4c4f83216ba81d"
    sha256 sonoma:         "7665a0a187f9662ed1619d140be24e3c15d6980042c84063fd3383830475e3f8"
    sha256 ventura:        "0bc812a9b65210fda7feb92935858ccd7dc3e8f38197829d2950a1939e524cda"
    sha256 monterey:       "1a3a191c9aa125dbed54f69f626134729bb1ad184ceef84b9e00b1d467420312"
    sha256 x86_64_linux:   "33aa9ebdf847d1d93cdf8aa456ae7966ee0d4e9e0f839ea11f567da153aced64"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
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
    system "#{bin}/gtranslator", "-h"
  end
end
