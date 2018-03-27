class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.26/at-spi2-core-2.26.2.tar.xz"
  sha256 "c80e0cdf5e3d713400315b63c7deffa561032a6c37289211d8afcfaa267c2615"
  revision 1

  bottle do
    sha256 "1562647b757604dc562e0ab1a5bf981fdab39c5c73c9075fae2c41e6655307e8" => :high_sierra
    sha256 "cc5e6d51e17edad2be3c57634637b22bb987db17a0d7d9e00392ed612449459f" => :sierra
    sha256 "9dcb96ac4adb8e3b3897ab1bc3f16a65984bf3c6f4c41566838233a0337fbf3b" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
