class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.22/at-spi2-core-2.22.0.tar.xz"
  sha256 "415ea3af21318308798e098be8b3a17b2f0cf2fe16cecde5ad840cf4e0f2c80a"

  bottle do
    sha256 "1b9abdcda5a9b11617bbc5f045a141460839138139e10485ad097d4a5b882afc" => :sierra
    sha256 "12c6825b2f9fcb778f5b559b204fa70a8ef8a53577d6a4d1b1f57a75f36a959c" => :el_capitan
    sha256 "528bba390a281c19fdd115ee7bcd917fae80696f461acf31e70fe8b6a0ca57cc" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"
  depends_on :x11
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
