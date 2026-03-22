class Gtranslator < Formula
  desc "GNOME gettext PO file editor"
  homepage "https://wiki.gnome.org/Design/Apps/Translator"
  url "https://download.gnome.org/sources/gtranslator/50/gtranslator-50.0.tar.xz"
  sha256 "857b51c78f54df42418ff6fa9e62b8554df7f021cb12338c1fc0d85b99c918ef"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8b3109a1729b655d93d1633ac69ad4400eec4df32265c44ffdc690d6f60e6bad"
    sha256 arm64_sequoia: "d3852d2a411fcf522fbb2b726666e792a0f9df79f9c1360583054e7ecf872b1c"
    sha256 arm64_sonoma:  "bb1248e9810dcfd4621c357697f45ad77fe7bd054a05dd1eb89f51b76512ae4c"
    sha256 sonoma:        "562065e41ea4d65419ddfef02430f0a3e69817e7b01e236cf1e98a51ca95e611"
    sha256 arm64_linux:   "64f3b299245f9a3dbaaf10a33f0912c821e7c7c77bc6db909fbc9d9a72db873e"
    sha256 x86_64_linux:  "96a0880c5627f73fc47cff866a6f173f0e966d760bbec15d14e036ced0bbfb58"
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
