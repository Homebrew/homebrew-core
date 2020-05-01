class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.0.tar.xz"
  sha256 "41da7ff5ba8e2425adcb64ca5e04c81f57ca20ec6fdb84923939fdad42c6a18d"
  revision 2

  bottle do
    sha256 "c2430f90cd6283cad1c2d72d678243c197c4fea78d4955f5525d3c966d765a04" => :catalina
    sha256 "2c4d3b3bac6ef674218933479ae5840093f974165322543762333537b944613c" => :mojave
    sha256 "47567b08fad94669cf398aceb7c75245b806721ede6938dd961156781d1a848e" => :high_sierra
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
