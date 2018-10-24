class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.30/at-spi2-core-2.30.0.tar.xz"
  sha256 "0175f5393d19da51f4c11462cba4ba6ef3fa042abf1611a70bdfed586b7bfb2b"

  bottle do
    sha256 "fba527a12118cfbb6668f6517e6edd875e0ffb5a06d8ef5cb7efce62f6f362e9" => :mojave
    sha256 "649bacc1ff2fa519645dd267e2ad3591a28777d0170c62dd94cb6b1bd7ab474a" => :high_sierra
    sha256 "55cfa9b412a347885868f9429e79a8757501d634608b3bc677fbfb573a812458" => :sierra
    sha256 "29cdd716e1961e90a94fd6a73a8f62b57f7a6180ce64aa23e08e84e61c0acd19" => :el_capitan
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
