class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/40/gtranslator-40.0.tar.xz"
  sha256 "ec3eba36dee1c549377d1475aef71748dbaebd295005e1990ea9821f02b38834"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "b90853dc169f42e8f9b1dddcc3af59a52c6809c07a011ec74676676e1aa34c61"
    sha256 big_sur:       "3a1ea832e3c5b8be45917df36d6229fde96c22e3a8077101d40c00367872b8f6"
    sha256 catalina:      "9ead77c72b7ee59d76a4c73c92cb93a29cee0cf7885bc8aab54eb672809baf0b"
    sha256 mojave:        "e5c88ca5952d0958cb3f9bacf25e63ca41ade68c86cb8c55648820fa672ca0ab"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "iso-codes"
  depends_on "itstool"
  depends_on "json-glib"
  depends_on "libdazzle"
  depends_on "libgda"
  depends_on "libhandy"
  depends_on "libsoup"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/gtranslator", "-h"
  end
end
