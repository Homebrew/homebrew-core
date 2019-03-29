class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.0.tar.xz"
  sha256 "41da7ff5ba8e2425adcb64ca5e04c81f57ca20ec6fdb84923939fdad42c6a18d"

  bottle do
    sha256 "f330d39c1cd4c6420b5d0bfa9c8382c9180e8e09e07cb87cf3b4100db7b493d8" => :mojave
    sha256 "f969a56e68b6d5c4f768bd16e3e2f52c9d4d44c6a51124059598bb92a270adf8" => :high_sierra
    sha256 "02eccc04224dbb48ac598e7e18c50be6a0669f657f6ce220d42bbbbb1e319f01" => :sierra
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
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
