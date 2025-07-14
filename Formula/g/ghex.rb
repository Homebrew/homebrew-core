class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/46/ghex-46.3.tar.xz"
  sha256 "ea16595dfba0a97b55dd106305d56ba2baee95de0b13b75e75966cc31f9b3ec9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "54e06c79c93adc5dde1d01e99e0507c63c8a3e703f0eb99aa27463f816236502"
    sha256 arm64_sonoma:  "bd685310597542ea92a025b43dff448f0f88bd67da205abe838b0c1993f25b28"
    sha256 arm64_ventura: "bf16d5c93b881c3dda405c4ab11d7f8f386d4a9528c875af98038408ccb8f333"
    sha256 sonoma:        "5a441f2016c5199795123e536f90c6c2347d864cc93d6eb4e8daa1b22115c0dd"
    sha256 ventura:       "74b18d5ad33151176c96441da1cf696ea1d14f65aee6070259db2c31eab3f3ba"
    sha256 arm64_linux:   "5c50542bd5285c92ab1a791aaff23fb3a4807327e4b8e5c8241323762f0600ae"
    sha256 x86_64_linux:  "ffe5201e2afd71f686268102c8cdbf5225bd5eecbb2e9a8253611d96ceba1134"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
