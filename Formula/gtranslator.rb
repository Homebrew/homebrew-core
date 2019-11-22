class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.34/gtranslator-3.34.0.tar.xz"
  sha256 "b2f25c02bdfd246896803756078c3006ef433c83eb802bc23a33413046bffb17"
  revision 1

  bottle do
    sha256 "159e755282296b401507b791b4c4b7121b995a8055b75271aca6c4ff95c7fcf6" => :catalina
    sha256 "4b5a43b5bd598eab15e66156b3491c43ad20dc7a226880ee9b720e4bb6b43188" => :mojave
    sha256 "17ac4683c97685ceedbda84a6680124f04d6181e2397c373633dc8c99eb835b2" => :high_sierra
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
