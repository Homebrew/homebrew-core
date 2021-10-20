class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.0.tar.xz"
  sha256 "20aed546fc882e78a3f186a0c8bce5c841cc3a44b7ea528298fbdc82596fb156"

  bottle do
    sha256 arm64_big_sur: "0eba3a8448818bc514031ca4f2e9c563230436cf384f3301f6baaab7ec979c98"
    sha256 big_sur:       "366463a087df79c6303e3e006b1de8c61df120ebdc87807a9e37693f8434fa5c"
    sha256 catalina:      "63a5e6ccc3cc87969fbbfc07714930fb23db1d31ad77f68b6c85d6fa618c2738"
    sha256 mojave:        "77ea79988421bf83540eada6ce6fef863f06b402b074edf5f5b20abbd47361ca"
    sha256 x86_64_linux:  "cfca8636a650f592bf9e28f67ef37a80aa87d2537b099bba9a98671ae09066a1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
