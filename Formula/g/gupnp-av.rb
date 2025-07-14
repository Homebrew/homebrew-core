class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.4.tar.xz"
  sha256 "21d974b3275cb5dcf5b8aa1d9a3fc80e7edca706935f6fbd004c79787138f8c7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "79a8014527ac4dcaa679fd3825136895f58105c679862632ab261a71c292a837"
    sha256 arm64_sonoma:  "70df7b1b747aa8120479ef27e1b276a04d37dd25c5cd9aadf0d24b64d3106c84"
    sha256 arm64_ventura: "baf6994783bfe3f86c1c6b3f8295f65fb6ce41c211f14647b685a07ac24c6428"
    sha256 sonoma:        "db6e942783e24b2f0d759a9025a390a109ba46fce4ba44b517728dd2b27fde1c"
    sha256 ventura:       "bd82d8dfb864237780f1af06de701b64aa96b45eb1e80efbfc02c9b06e156429"
    sha256 arm64_linux:   "22f5c8aabe72c050c14018cbe29d7373abc52920468feb62c44d98c9eeb62dfc"
    sha256 x86_64_linux:  "d44e06884e91c2865c06455ce6300d3713404a70472ecd8505880df133fd5064"
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
