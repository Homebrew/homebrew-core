class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/46/gtranslator-46.1.tar.xz"
  sha256 "b4af3184891491fd89c1a0465652310156c07d156b6a24e1c07f3a4cf7579568"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "fbb4c4aaa2d292c41f7b9026a336581b861fd665f98955c14576a3638bd63aa1"
    sha256 arm64_ventura:  "98b7deff1b67b1ef789a461669cc008629e27f2338f1629539e9d29a6ecf1841"
    sha256 arm64_monterey: "013ac98c2e2d0b73d8505e8037dbd46c7046df35e320ab66580fbf757f65930d"
    sha256 sonoma:         "cc38acbdb52fdad5d9adeee5ffeb9abcdb517967856c0f8bec26a165ed90f3d2"
    sha256 ventura:        "1947fb586d1218db9977a77869c130742db4db07a4992f119ba84ac0dbcc06bb"
    sha256 monterey:       "809b20c039c167429a5af8ed8ba73c32a59808e14d434e03ee029feefda9afa1"
    sha256 x86_64_linux:   "c41a8150fa0f64e40c47a0c00f121a8005656d9b678671faac04c6389018234e"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
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
    system "#{bin}/gtranslator", "-h"
  end
end
