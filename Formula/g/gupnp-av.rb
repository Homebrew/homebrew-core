class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.4.tar.xz"
  sha256 "21d974b3275cb5dcf5b8aa1d9a3fc80e7edca706935f6fbd004c79787138f8c7"
  license "LGPL-2.1-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "f06e97478af782faa70bedf35dd2413377774f378aaa3ba60acf34546f402473"
    sha256 arm64_sequoia: "36fd7243bfd671aad12ce90a1b42a513be68fe18b5d7f48e5d3baf2663c02d0a"
    sha256 arm64_sonoma:  "98c42ee2c8d2070a6b52aa7cfd4f068fa9728a0f153975b098898f0517bcc082"
    sha256 sonoma:        "2081869e1ec9e06dc5476636f27ad48bede7e7307a9dead6aae43a0ce2c1f687"
    sha256 arm64_linux:   "06135313292f8568506ac9a026adfbce37567c4fc0b1d9cca8b1ca8a693ef3ef"
    sha256 x86_64_linux:  "cc49eb0fec7bd6b617c2c264fdec75d440d315b97849d5e2c92ae5f8eb4ae042"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "gettext"
  depends_on "glib"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libgupnp-av/gupnp-av.h>

      int main(int argc, char *argv[]) {
        GType type = gupnp_media_collection_get_type();

        // Check if the type is valid
        if (type == 0) {
            g_print("Failed to get GType\\n");
            return 1;
        }

        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gupnp-av-1.0 glib-2.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
