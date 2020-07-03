class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.0.tar.xz"
  sha256 "41da7ff5ba8e2425adcb64ca5e04c81f57ca20ec6fdb84923939fdad42c6a18d"
  revision 3

  bottle do
    sha256 "50ea87e51a1ded32ea3aca221e05f0b9812994b36c659069567bc05d30c4355b" => :catalina
    sha256 "9bac2d4f913429bd683502cb4757fd58f119cb0e16d7f4ddce26df6ff1187d2d" => :mojave
    sha256 "a7be90e6f182e9f3650db2de237532d45453b71986b97b808c51ed3e204837c8" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
  depends_on "gupnp"
  depends_on "gupnp-av"
  depends_on "libsoup"

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
