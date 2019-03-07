class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.30/at-spi2-core-2.30.1.tar.xz"
  sha256 "48d7df351e73a63062648d3c4c15f4b353e8c835be2fa772f50308533d5a9eb0"

  bottle do
    sha256 "8b7fb852d3615978ab46bcbec799242fb5d4fb55b62490e919b27d0de3e96870" => :mojave
    sha256 "70ad54946a31cfcd547087f1654aea04aa3416fb83220a8b463d43b8c8e88ed0" => :high_sierra
    sha256 "bbe4f793cf60720e34765c4954b61b543da42d35f451fa04211ce65a28bdaa86" => :sierra
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
