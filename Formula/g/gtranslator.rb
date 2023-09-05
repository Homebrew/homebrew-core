class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/42/gtranslator-42.0.tar.xz"
  sha256 "2a67bcbfe643061b0696d89a10847d50bf35905ff3361b9871357d3e3422f13b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "eff3164e795130ffbfb819d020f10d12c7c26433645d41258f9168b179a5e0fa"
    sha256 arm64_monterey: "c9dad313a4b72b1a06828305fd3c7be3cdc9ed990faac40dc8325245d19d1a23"
    sha256 arm64_big_sur:  "7dc1c16652e097e44e7e02f3ad95c361b208426517898de58160a98b8a1361a4"
    sha256 ventura:        "d1b51162cd3762bf620685a287603026937831e492896ccbfb99485a9516e031"
    sha256 monterey:       "6f82d622765a3269c0b0bca386ee425375b369f20d1eaa2bc5b9fdbe19951998"
    sha256 big_sur:        "c4b68d96cb52329c1ae13d146ce5d76ed47a8d92be5ae33022af2194e14f353a"
    sha256 x86_64_linux:   "bbd7b7cc4d3466f46bac926ae3ca16ab81cbeadd13baafdd7dfe550d530e67cc"
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "json-glib"
  depends_on "libgda"
  depends_on "libhandy"
  depends_on "libsoup"

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
