class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.8/gupnp-tools-0.8.15.tar.xz"
  sha256 "336ef4a09b9fc83444a1594c8215e2bed55fbea5b6d1bf6b54c63104b4c497ab"

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
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gupnp-universal-cp", "-h"
    system "#{bin}/gupnp-av-cp", "-h"
  end
end
