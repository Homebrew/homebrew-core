class GupnpTools < Formula
  desc "Free replacements of Intel's UPnP tools"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-tools/0.10/gupnp-tools-0.10.3.tar.xz"
  sha256 "457f4d923935b078415cd2ba88d78db60079b725926b7ee106e4565efe3204de"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  bottle do
    sha256 arm64_monterey: "4a8eeaa71391a753f942f64f84a8f025b513e0252c773f7e819516323dfa7be9"
    sha256 arm64_big_sur:  "4a89ac625c324da31a85f5c00a109dd40074da7546219596ed57ec640950f6f2"
    sha256 monterey:       "01c141f24a86702b11699b6e4bd0544b0e0ecbc3a4bc5e8936603bcf383df8b0"
    sha256 big_sur:        "1c0669b9521ee028984176288ebe98da99f05092da4e887d286317e39a9b1df4"
    sha256 catalina:       "745c99c44c7aab8b7c609ee679d4867cda900468759ce3abbb2624222649af2e"
    sha256 x86_64_linux:   "002c5f55aa4ac266d215a73ae4336dcab858f3aea5da1977b5c77e532d3699b7"
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
