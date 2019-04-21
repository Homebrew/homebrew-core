class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.32/gtranslator-3.32.1.tar.xz"
  sha256 "e1b37b0436684eb3079916eff7b6eeac2cd51ebbf8d2d6f35b5480ca0391b4da"

  bottle do
    sha256 "14135e672b3f7305cbd16823c6863ec4dc2ed16153ab93c3db410e3b8347e1a8" => :mojave
    sha256 "9497d5b1079b08c4f28b1e816e0a8882220051d27d3762f0e0843233facde50e" => :high_sierra
    sha256 "d11be689c651a4d27db8328cf8c5396befd791abd2bb8f1c9a7b4174cf528434" => :sierra
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
  depends_on "libgda"

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
