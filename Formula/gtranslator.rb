class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.32/gtranslator-3.32.0.tar.xz"
  sha256 "aa8b6ce7a6ea199a50ee8f65258e640af80407a7433359b853039a7ea07a11b7"

  bottle do
    sha256 "9abc09ece4d2f3cecb23ae250cd629944635cf99a383a9c6fa2d586aa752397d" => :mojave
    sha256 "09420392739bef69c8ac566c6e67da633063e08bae0d8bc12891049e55cdccb8" => :high_sierra
    sha256 "255b8d81b662bc86f416c07a9ba5267759fc29e59b33c9c61d02aee527a0b534" => :sierra
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
