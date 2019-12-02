class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.36/gtranslator-3.36.0.tar.xz"
  sha256 "2daa1d3b59b4a35ef54df087345b03e1703e725081f9dac543539228a715add3"
  revision 1

  bottle do
    sha256 "90ddfb2acb333a7fb7ee2ab3d6de67c370cfcf05b4644c389dab6da55ae09698" => :catalina
    sha256 "f812c486897ba964e13cb02fc17e3f1d02ff9c78616eee69d055a3fd1d72120a" => :mojave
    sha256 "4657887f0ab62e4d4ed176d7625cacc752d2bf9d8a93e05404d26aa8a3b09fb4" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
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
