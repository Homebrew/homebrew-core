class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/16.0.1/gucharmap-16.0.1.tar.bz2"
  sha256 "d687d3a3d4990ea7aff4066e17768ec9fefe7b3129b98090c750b8d7074b4764"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "59c2078b02091d1593f343e119926f473cd2aa5359eee1534cc11b441578a42d"
    sha256 arm64_sonoma:  "117758c84c20d2567903bf4b651651d2dc9f9eb753be9f1950db0ee53cb7ba4c"
    sha256 arm64_ventura: "b65e687de46f9ceedd7ff3ebd80eca45972e53d6a436a5cbdd9bec771e7b1253"
    sha256 sonoma:        "d6e92e03ec4db37ebe3462f0c4cd447906b792b77d81bd94bd290a01c9f5e575"
    sha256 ventura:       "00753bea75c91a51c05f257b25c18f7154a927cf5c9a2af0470fd7a8f9402826"
    sha256 x86_64_linux:  "e632139ec368f5c381680b3c9ee46990694899d9148f61bba94c7bcb7aa1818a"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/16.0.0/ucd/UCD.zip"
    sha256 "c86dd81f2b14a43b0cc064aa5f89aa7241386801e35c59c7984e579832634eb2"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/16.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "b8f000df69de7828d21326a2ffea462b04bc7560022989f7cc704f10521ef3e0"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", "setup", "build", "-Ducd_path=#{buildpath}/unicode", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gucharmap", "--version"
  end
end
