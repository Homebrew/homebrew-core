class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.20/at-spi2-core-2.20.2.tar.xz"
  sha256 "88a4de9d43139f13cca531b47b901bc1b56e0ab06ba899126644abd4ac16a143"

  bottle do
    sha256 "d070616da4fbb93abf713dc77bf15138b84b8cb016e39acab9a54e8a881207aa" => :sierra
    sha256 "40a55aa9e0cef4001e7d719bfbb0de996f672dbc8fd958edef4be36ee618d337" => :el_capitan
    sha256 "44f8249e62c62e673d829576302c77b7822101225f3a0af00df056ba4840c443" => :yosemite
    sha256 "25c2ca95b2d510864ca2b5dd1559172723e94379818d5ded683fad3de9b30119" => :mavericks
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
