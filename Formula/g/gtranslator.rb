class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/45/gtranslator-45.1.tar.xz"
  sha256 "3acedb9abe614d7cdc9d2faa86e84874379b67102b7a2ae5e211b4973366fa1b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "f586c501bd24b6ca4d4e5ca445ebd19715ca29fb765e018cd66e005457735a5a"
    sha256 arm64_ventura:  "61cf039bb4362e98d731501260924ef76e9445a9310c9455b7bd26fde3fd7749"
    sha256 arm64_monterey: "cc059206ca3c9b7d7ca548d5cbebc816dd06a63749831c9cf7b38815c69048b2"
    sha256 arm64_big_sur:  "afe0e0a5515dbb37a4dfb88f24df5e55ccec8f60b48f4faf1fde0a7e35df3f7c"
    sha256 sonoma:         "96c0359dcbe159e6f4dcbc9da475ffaf1fba618f7f755b89f903e58a55e1c763"
    sha256 ventura:        "c5b81f35d74ace642b5ca021b66fcbbccd698e7b5b201a18a6bd9c2224d78d65"
    sha256 monterey:       "1d90ef4b29f547ebdeec2a682853ba56fcd0d267accbbd6f4c11b74ab317e1ed"
    sha256 big_sur:        "a35148b3288d358ad4f1e87175deeaf25c8f26b524b9d14cbbc7f8caee8f29cb"
    sha256 x86_64_linux:   "c025b942d184ca66e24c3d3f169d1849f2413290c888c31715f571e07d449534"
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
  depends_on "libhandy"
  depends_on "libsoup"

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
