class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/48/gtranslator-48.0.tar.xz"
  sha256 "e78ebc2006a251d8796ed1e72b9c2e53647973707e65b74d9f94521b03929e9f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "fbcbdf1b0c13c0333ab1f149aabab989a49a674026ad6b1dfbb080dbbe262de6"
    sha256 arm64_sonoma:  "580ba20e94c0065f9de1136ed40ff1ee2c9099ec8953f9ce6cd054f18d5db6a8"
    sha256 arm64_ventura: "25e6488bef8333cdcf5cdd7bdaebcaa9b4aed313b7d622c63471cb0dd283cb15"
    sha256 sonoma:        "726b1853ffff31972de87fe405054ba68275e37795ae9008d4e32b261b87822f"
    sha256 ventura:       "b0a7410ae57d2dfe88fb9b1b24280c17be9f0328391ce5d8c4daeb988ea7cd61"
    sha256 arm64_linux:   "3ed87f53f600bfa97ff051503934004292f80fcf87bdfe3ccfd4df0dee35c092"
    sha256 x86_64_linux:  "f90143186e87fb3d3216ea137e1976b4d60fb3e77fcbd0ea8b2444de389358a2"
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
