class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.1.tar.xz"
  sha256 "4ea96d167462b3a548efc4fc4ea089fe518d7d29be349d1cce8982b9ffb53b4a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 1

  bottle do
    sha256 arm64_big_sur: "d274a21bebdd1eecbb3663acc978b7db9a02fa82dd1bf6a6ae580d6342b41d86"
    sha256 big_sur:       "43bac77ff6e404437bc158f13f15e041ec557b34d8fe98ce7f83062e145f73ba"
    sha256 catalina:      "fda7b6fe97dcfa2710e8a0a7065b9c07e208068f7244c1a04a02f1b3d02e3127"
    sha256 mojave:        "3845534111bcb148335d74b0417ecb0ebf6a0dc328232ed0a74b39e703ad25ef"
    sha256 x86_64_linux:  "5c4fbc6f649a4d84b29a27dd372d1c2459d5d24fc93c8b64f36468408a07f951"
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
