class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.0.tar.xz"
  sha256 "41da7ff5ba8e2425adcb64ca5e04c81f57ca20ec6fdb84923939fdad42c6a18d"
  revision 4

  livecheck do
    url :stable
  end

  bottle do
    sha256 "38763acd7675374f6fb83bb6fc9c11fd66cc0b0e76b1dc1f16a1602ea73cecc9" => :big_sur
    sha256 "f1686d0d5c09941c2b86710da491917d38e0a6395a035048079f324e4ef6220d" => :arm64_big_sur
    sha256 "4100de40650880fa3ad8023c65e07c651aaf1286da8865a3e865f55016eb330e" => :catalina
    sha256 "6a4d56ae6c680111619ad67125ffe3ee96944404771bbfdf7cdf6db0322a5379" => :mojave
    sha256 "b4e8473364799562c90c9637f33b5ef999c53d7404eac8f6ce2921f62d056324" => :high_sierra
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
