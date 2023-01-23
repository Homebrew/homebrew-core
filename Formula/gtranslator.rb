class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/42/gtranslator-42.0.tar.xz"
  sha256 "2a67bcbfe643061b0696d89a10847d50bf35905ff3361b9871357d3e3422f13b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "6271144e4bfac02229a6039cbde55ea5dc0022b4d6327cfb642307f384cb6a5c"
    sha256 arm64_monterey: "15e9c85730e88ddb9544d01722e972bd6b68b3baab42effdf25a585381d90772"
    sha256 arm64_big_sur:  "e787ad4e441d4ecd4d9c328fb18d2384a21862b0a389170ee54cbbd01879a556"
    sha256 ventura:        "60e7cdef5ca027b32bd7405c6e6efac3cb029c44f4259933a9d71cdec645321c"
    sha256 monterey:       "25908591830110dc32edc52b04ef4c3dbf296b782d1ace73191826205a889fd3"
    sha256 big_sur:        "8a5b528e062820cdc3ebd9b024b4e96f3ec2d65d521b03026828d32d748774e1"
    sha256 catalina:       "91dd2d4c85608fb04f7a4f92423dce39ab2ab04a3f11152c30efad1bd96f14c6"
    sha256 x86_64_linux:   "8e7e8ca6e284f89497170bd47e232d47c9db1566b2e6c5835cc615086bdeeb58"
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
