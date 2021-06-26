class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.1.tar.xz"
  sha256 "4ea96d167462b3a548efc4fc4ea089fe518d7d29be349d1cce8982b9ffb53b4a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_big_sur: "d56367e5b3d25701a48cf3d5201df841117e4d25003094766ff3e2267f81bc48"
    sha256 big_sur:       "df4b690dbadf285baee9134c1889ca57bc57b0e527d8fb54a33ea6a980d7fafd"
    sha256 catalina:      "e6d6066be38a1fd40b1ec0510306dcea50291348cc5cad25b5e899fd20ff6467"
    sha256 mojave:        "5b04336ba67f125c40593657d1e60ead0aa0578265efb9d4fe254f9e06781b78"
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
