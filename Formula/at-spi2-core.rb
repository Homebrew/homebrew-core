class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.24/at-spi2-core-2.24.1.tar.xz"
  sha256 "1e90d064b937aacfe79a96232ac7e63d28d716e85bd9ff4333f865305a959b5b"

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
