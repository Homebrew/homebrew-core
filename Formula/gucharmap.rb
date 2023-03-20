class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.0.3/gucharmap-15.0.3.tar.bz2"
  sha256 "82636e4a5baacad795430a0de129450e84a69c4b1d68d007128c5023f9a82417"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "00f964c8f021e758906253670ead429c79f57dfd89ea35d7ba7f66e8be30deae"
    sha256 arm64_monterey: "ee7a2aec333c215a3f6bace5c3785cf5c09e85f0d4b5a7d2438d7fe067363706"
    sha256 arm64_big_sur:  "acd3d9cd2ee5ebf337a6052c73a3e5199a96035344f9e55aabd475c74b77980c"
    sha256 ventura:        "683c632a969b05c6be2d97d5fb58fe1619a46421ecdc3c7705c401d2e653500b"
    sha256 monterey:       "8ce3dd619faf86166d58107e61d5eae25640b69b4907149caaaa62000f766807"
    sha256 big_sur:        "e9e480dcdfbe970303bf771d30f1dbf4b44225dae90c0016d7794713c3e60ca9"
    sha256 x86_64_linux:   "a996a400de1d46836d6499d747e242417f983fb4b79e895d229a3d881bfebd0e"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.0.0/ucd/UCD.zip"
    sha256 "5fbde400f3e687d25cc9b0a8d30d7619e76cb2f4c3e85ba9df8ec1312cb6718c"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "24b154691fc97cb44267b925d62064297086b3f896b57a8181c7b6d42702a026"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system "#{bin}/gucharmap", "--version"
  end
end
