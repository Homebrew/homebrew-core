class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/49/gtranslator-49.0.tar.xz"
  sha256 "eaa85620949d5c27c142219fc184281b229dc31eea3717b5b86eee70dcdcc1e6"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "8ef70f227a7d23e55dadd47d469b18f05d348e963138d51f9a95c7af26cdb875"
    sha256 arm64_sequoia: "7b3d6ed55bebeaebdd437b0c01c2e0406244bb37017f6c67703391bd37002f46"
    sha256 arm64_sonoma:  "92e535473667bcef27ab9bcddacc141e2d1e75ee84285b6eccd22aff45b42c79"
    sha256 sonoma:        "79f86b1f246d68aeb8379ba44b516f7dc6d65a6468d8e24cffb23a8d512482f7"
    sha256 arm64_linux:   "2934cc290f01a16a4460ddf9c3bffdad423e7f36434bf660de959ffc1f1c9782"
    sha256 x86_64_linux:  "c07eb0e8f150bb544073e24691d46cfcff6cbe3fedba16ce194f5da20faf749e"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libsoup"
  depends_on "libspelling"
  depends_on "pango"
  depends_on "sqlite"

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
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gtranslator", "-h"
  end
end
