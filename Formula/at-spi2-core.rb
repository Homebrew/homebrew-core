class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.30/at-spi2-core-2.30.1.tar.xz"
  sha256 "856f1f8f1bf0482a1bc275b18b9f28815d346bc4175004d37e175a1a0e50ca48"
  revision 1

  bottle do
    sha256 "500ac594025a42f969e6166771f551abf0be27afbc0de2048bf0d65e763ee9b4" => :mojave
    sha256 "cdca60e8b2787cc2694aa3d744c641bf68f8dfc835065bab63123d53a2c3c622" => :high_sierra
    sha256 "11b05e7002247ae75a1f95c381b1bc4fe7839efca2f01ff882fd5b4e23a3668c" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
