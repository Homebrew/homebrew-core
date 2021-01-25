class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/3.38/gtranslator-3.38.0.tar.xz"
  sha256 "dbcda9b81a22d9233be18e99fd5c448f6ab05759d1e94c10580bb831ca2d7635"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "87af99ef6bff1ac84eb04b70b0923040af2588909078f42ee2926620ebf9fd5c" => :big_sur
    sha256 "5d5883134917ac1a97cdaafd240fc9f162843e8cc053954bce1381e893663d23" => :arm64_big_sur
    sha256 "ca6600f0f0d75cc1f9c2a063ac2ad6bdfe790fe89a72533307deda968903eb2b" => :catalina
    sha256 "d46199ba9a6eb1a9cf068fe5a9ae34529ab60b70ebdaca2f29c82e4eef86d34b" => :mojave
    sha256 "13cc15d49f5c39f4be9f28860b6e99d7186d7b985fa03308f3a185692f57ad3b" => :high_sierra
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
