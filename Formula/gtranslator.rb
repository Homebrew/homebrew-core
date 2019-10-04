class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.34/gtranslator-3.34.0.tar.xz"
  sha256 "b2f25c02bdfd246896803756078c3006ef433c83eb802bc23a33413046bffb17"
  revision 1

  bottle do
    sha256 "114a61ce832494efc67b22803bd8a5df32156ceb5e8b385e15fb69870548c522" => :mojave
    sha256 "74f66ffe82e339efbaba054bd4d2fead07d3998992092da4ec7ba5af24384c64" => :high_sierra
    sha256 "8dc2ce8c6a9113405a6e56d98f06b31fce8ad6d69d2ceb7f1cb6e1862039b047" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "adwaita-icon-theme"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "iso-codes"
  depends_on "itstool"
  depends_on "json-glib"
  depends_on "libgda"
  depends_on "libsoup"

  def install
    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
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
