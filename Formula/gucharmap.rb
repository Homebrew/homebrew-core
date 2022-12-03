class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.0.2/gucharmap-15.0.2.tar.bz2"
  sha256 "ab7317cf111ebe2efe435a68c65d5866923ad2f8c256dff1089fe2ff474b8470"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "f2189076d65032f0af2bbefd96cc9c1d45edf1e1e10ee55d27161bdb96322fc1"
    sha256 arm64_monterey: "2ab550cb50402b26344906c8c95a382c20ad5d4766af60dd108291dbc21e1287"
    sha256 arm64_big_sur:  "6d047b2bf167d9223971764424d87154806bcfea1d58aa5caef0bd617a93409c"
    sha256 ventura:        "0dbef9eafcf5a456dc5a439ade28cde02836fda2febba4b75d6666cff03d2653"
    sha256 monterey:       "1e763d5bcb4378746ca65906dc311a8de8e2033515553681b190c2174da5f07a"
    sha256 big_sur:        "9ac9bf2ff4e6f67e7a1ac6c8735f946d61ff3e5c890bf8731fafcf841c1903f1"
    sha256 catalina:       "d7c620b2047b336cc1799fad8a375c0cb3a2e68aa95c51c2395f4864cbe682af"
    sha256 x86_64_linux:   "79c22196d28cf96734c24dac91d9540c33e256a9c7261fed06bb90489e36536e"
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
