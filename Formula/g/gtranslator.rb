class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/47/gtranslator-47.1.tar.xz"
  sha256 "c91c0264b9a99e3091ef911f731a8ff6d09a84a2bcd75e5651971da6bbea6222"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "9528d2d0c63f9fc72e116c529635b9a1062c378de167317f533eeb19f26b3ec9"
    sha256 arm64_sonoma:  "dbbbb590aa84894918b7d13179f95c4a5e3048df1707ef285011dc070e09aeeb"
    sha256 arm64_ventura: "44f9fae1b4fcc02e8cd7cb1c81162e14a7122a17046e14f719f11faebbc01983"
    sha256 sonoma:        "a7bee03217bdf2fec854a4ac33c6fdb7dc2a73c230f880aa51c162e6f0a25487"
    sha256 ventura:       "b9ced5aee8dfac8bdeaddb5be0e3221660298cbb622dc8739a5112c3fe9f696c"
    sha256 x86_64_linux:  "0c4b171ded4cde9d2cd935af1d7e8993cd28d9a929b11d8bbbca29ba45b87c35"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

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
