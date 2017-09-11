class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.26/at-spi2-core-2.26.0.tar.xz"
  sha256 "511568a65fda11fdd5ba5d4adfd48d5d76810d0e6ba4f7460f1b2ec0dbbbc337"

  bottle do
    sha256 "ebba4778d9ed5cba76f02841670195ddd5abd81e844c44262440a7c279170577" => :sierra
    sha256 "5caf61f65d7c94d2e197135fc751568362b6d7f8f2ef2b62259c5270c3870628" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
