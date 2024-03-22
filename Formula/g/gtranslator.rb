class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/45/gtranslator-45.3.tar.xz"
  sha256 "3010204df5c7a5ae027f5a30b1544d6977d417f0e4bb9de297f0ad1a80331873"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "5fb14d2c828cbb684b8f302ad56478eb5988b0c0c6b7f92dbdf8bf8bc7b514ce"
    sha256 arm64_ventura:  "bc7c2ce82bf3cf452077bcfd2906a8fea222560f59621bccd82655025f407943"
    sha256 arm64_monterey: "67467375492e60ae25f7f48f376c73a5b7f19054b0aac5407cb14b77a75eda62"
    sha256 sonoma:         "de8b1397f02ab800154c23fab0e5fa949077beaf695bcc3ba4eb8b26c4f3a9b7"
    sha256 ventura:        "15b87f6323d70be30998ce0a5e60875916fb0864d52e3240cd18538ecf75e279"
    sha256 monterey:       "81157827b02db1fef21645f3f51144f4bf263f7c94452581e087713f39c845d3"
    sha256 x86_64_linux:   "74977dc28b39a0f2de7d5157094fd40acbb46fdbb4ad531b61f540a36a7e59ce"
  end

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
