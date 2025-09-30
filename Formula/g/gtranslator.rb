class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/49/gtranslator-49.0.tar.xz"
  sha256 "eaa85620949d5c27c142219fc184281b229dc31eea3717b5b86eee70dcdcc1e6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "c3989a78b0ab3a2c895f893703396ab059c661745f79178ef2b0ff45a32cd18c"
    sha256 arm64_sequoia: "9eff3bc6ccd0b6b83284c24ddc1e648c9a14d4dbcb9a287cf5111c6f5e6817cd"
    sha256 arm64_sonoma:  "d1bc0305b18832a98916975872bd68f8d3bff4e087a7a51cb676ba6406204af9"
    sha256 sonoma:        "0f59c2ffe4ba03104573371c17a007da03489a6b96a0116e987f2cf692ffdaed"
    sha256 arm64_linux:   "4cbc02955f5ba3b50b6388022d1509497c734daee3cd8a2cf8d01f32391daa62"
    sha256 x86_64_linux:  "71523330a550458d9b692d09d58484e544e5354943e41b31f167ba2383a0793c"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "glib"
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
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gtranslator", "-h"
  end
end
