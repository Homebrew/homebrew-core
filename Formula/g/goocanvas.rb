class Goocanvas < Formula
  desc "Canvas widget for GTK+ using the Cairo 2D library for drawing"
  homepage "https://wiki.gnome.org/Projects/GooCanvas"
  url "https://download.gnome.org/sources/goocanvas/3.0/goocanvas-3.0.0.tar.xz"
  sha256 "670a7557fe185c2703a14a07506156eceb7cea3b4bf75076a573f34ac52b401a"
  license "LGPL-2.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "fb3b0618b234fb12e646ae2494b14e83ca2d5ee50c4d7891d4a2914b7a88763f"
    sha256                               arm64_sequoia:  "8bd21a150d98f2abed5d68ac690487f1d2311e509bc54087d8b577a294bd6711"
    sha256                               arm64_sonoma:   "e700e5fb6f0f6454c9cc42975dae876c53f62ec1e6f5db3acadfea35232b72c5"
    sha256                               arm64_ventura:  "337609cd9eec8d0ca6502b73524cb5f86bc07ce6527438266a61ed253de5dcea"
    sha256                               arm64_monterey: "c5e356f708724c16f6594833df9ecca148f0e24862edbd3e8cb7632780cef5ea"
    sha256                               sonoma:         "6994404c6b91d235eda6a3a10b5a3a1a6b268d1fbbcdbc81ea3d538b19c71db0"
    sha256                               ventura:        "555e4e209cfcb7476df00bba6e4c23e99c3dddf938bdee7389f454cfc3dc7aba"
    sha256                               monterey:       "142e227274383dbc2c9e492f4cd84b9d12299fbb1a59813ce0d67eba5455e305"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6c3bb638ce2932282d43879c06235c8f16d0548f2be355ee19b480266b253792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33355d4dbdef036db01c5948d764d8202047838d08a68c1de6d323e5f18bc6ef"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkgconf" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-gtk-doc-html",
                          "--disable-silent-rules",
                          "--enable-introspection=yes",
                          *std_configure_args
    system "make", "install"
  end
end
