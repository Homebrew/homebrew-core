class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/47/gtranslator-47.0.tar.xz"
  sha256 "76e1041c5efb0a88ba18764ea4588b4e1965fa50314e01a173fa3ea0150e1cd5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "1e473c7592f9b6dc332a0049af39d727b9e4c8b1f7ebf843a92154fcdb32d6bd"
    sha256 arm64_sonoma:  "7e7b138e0dc182365fc4bb99406151be2027372373c7e16ba4cb3d0919204120"
    sha256 arm64_ventura: "dc8bb4262e2d1d2a8857baf69baeb1943eec349315474bb914234bbadf8e2375"
    sha256 sonoma:        "11f4a42717bdf883af7df730e03a819efd251f38a977847e50d518ace5d27a0f"
    sha256 ventura:       "04e159d3c6270a9e7c6d3225dea348ba419243d61260dcba1042daf89a087b6c"
    sha256 x86_64_linux:  "5c476514d3e7c3cc031ef9267fdbef4b26e0116132c9db529c125da04a8a3d44"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

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
