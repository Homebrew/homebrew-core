class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/40/gtranslator-40.0.tar.xz"
  sha256 "ec3eba36dee1c549377d1475aef71748dbaebd295005e1990ea9821f02b38834"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "e787ad4e441d4ecd4d9c328fb18d2384a21862b0a389170ee54cbbd01879a556"
    sha256 big_sur:       "8a5b528e062820cdc3ebd9b024b4e96f3ec2d65d521b03026828d32d748774e1"
    sha256 catalina:      "91dd2d4c85608fb04f7a4f92423dce39ab2ab04a3f11152c30efad1bd96f14c6"
    sha256 x86_64_linux:  "8e7e8ca6e284f89497170bd47e232d47c9db1566b2e6c5835cc615086bdeeb58"
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
  depends_on "libhandy"
  depends_on "libsoup@2"

  # Apply upstream commit to fix build with meson. Remove with next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gtranslator/-/commit/7ac572cc8c8c37ca3826ecf0d395edd3c38e8e22.diff"
    sha256 "cc93ba73ab5e010171fa21d5e345a2b4f69773bc786d07952181f86d1b66f368"
  end

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
