class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/51/gtranslator-51.0.tar.xz"
  sha256 "2dc283b4e36624064bdc85e657eb4de1eb01feba62a1b0eb3b2221fc6c02c75a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "a6d399223174174830bfdaca7969447dd822866305bf17fb84172aac2473da18"
    sha256 arm64_tahoe:       "a31efb66e77100c660097fdc464a80b0d2a0290cd66ccfab0ae57595ad874556"
    sha256 arm64_sequoia:     "0b835e5c0d0860ac633eccc8701a8e60bf2b5a2b0dbbf4e4c0aae5e7226758cc"
    sha256 arm64_linux:       "9076c79c59afa58c4974b1b15c92f01dc3a9faf0a7fd44060dccf893b539b2f1"
    sha256 x86_64_linux:      "6e8efdf23856e98e2eb0bc2c502086aa218544ec70142a16c4e88c080b2020bb"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gettext" # needs libgettextpo
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

    # Fix to ERROR: None of values ['gnu23'] are supported by the C compiler
    inreplace "meson.build", "c_std=gnu23", "c_std=gnu2x"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"gtranslator", "-h"
  end
end
