class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.1.tar.xz"
  sha256 "eb270b35b41b8f78a830ec83e1b89b7caeabed032922035b9e129edd95598178"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "f784d3d1960714d040fe90c5e8c0dc86f07d096d4d1b5c80557300b35e6a7e6b"
    sha256 arm64_sequoia: "8e795a39b5182e75eedd7fd638ce6ce21d891c0b9c9af0fdd1915c41adb1b651"
    sha256 arm64_sonoma:  "1491ec8c2c630a26a15137143d6d78ef757b83f63e5ae54b921dfe23b1ddadc2"
    sha256 sonoma:        "903a84cad4343464fe71ba8de8dab34e5486e35a0d58a0796d62f8120f912de9"
    sha256 arm64_linux:   "0dc843b1f0f170cd5ca9157a0d23a53f2a1f8292cdf1b08bf1f17370f2888d88"
    sha256 x86_64_linux:  "dfb18aec374e129414e093536fe11f9a6c3140637ef94c4b69c68b712259cb35"
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
    system bin/"ghex", "--help"
  end
end
