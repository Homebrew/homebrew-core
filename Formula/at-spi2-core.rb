class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.26/at-spi2-core-2.26.2.tar.xz"
  sha256 "c80e0cdf5e3d713400315b63c7deffa561032a6c37289211d8afcfaa267c2615"

  bottle do
    sha256 "ebefdfdcdf6a11d4e46aebcb3c327f682188d4b4d2ebe3f43ed143e7dcb0126c" => :high_sierra
    sha256 "3e6cd54451efeaff9b94313b461fcd75d82c2e6270625192b7680cdb57f67e4f" => :sierra
    sha256 "a655a6d84bc3d00a4cd4be87393e77e51ca65216c23b036732b6bca1bcfe5b54" => :el_capitan
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
