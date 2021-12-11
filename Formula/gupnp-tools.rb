class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.2.tar.xz"
  sha256 "6de49ef4b375b8a164f74b766168b1184e0d28196b6b07a4f5341f08dfd85d6c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "36bf2175ee855efffc394ee905804020bd28b2f345ce345b0f86c9f1faae84da"
    sha256 monterey:      "15d9b56880693e2c80bb77821a307abe95631448915f376d875098c942b15ec1"
    sha256 big_sur:       "70ed3d849117fd48c18b5d26313b6bb17a73c642e30ef85158e75fe71d90d9ce"
    sha256 catalina:      "163c7cd5916785f32193cff6543a0533aff92e576a83871c30474607a77d86fe"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup@2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
