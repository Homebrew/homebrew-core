class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.36/gtranslator-3.36.0.tar.xz"
  sha256 "2daa1d3b59b4a35ef54df087345b03e1703e725081f9dac543539228a715add3"
  revision 4

  livecheck do
    url :stable
  end

  bottle do
    sha256 "4ccb72c556347cbfe159eddd9688eab723a632130ae82325b317544e7c87b381" => :catalina
    sha256 "fc6c448bb1c7be26d4bce14995bb2946d65950445fdd44875790d223aed1d2e7" => :mojave
    sha256 "06b05625ddbc8f1f610ecf319ef9bb9d896d83780f7cb48ff2c5ca9cdde7c47c" => :high_sierra
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
