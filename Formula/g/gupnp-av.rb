class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.5.tar.xz"
  sha256 "93918fcf5af529fda5b3d2d9fc3b77cd93df88064939b82f249f5577d8de1c02"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "7cffeac0778be7f126b8fc2747d2364b679a61898eae3080a8d9118f04d0ee65"
    sha256 arm64_sequoia: "8c717b7221ffbee007db57f927bf9a25ca05ea0186a9a65464f298315bbaf41f"
    sha256 arm64_sonoma:  "744ba4d42e6b4822842218b8ed07ee1891684bd8eb2568d128d2a58c7b2784ba"
    sha256 sonoma:        "827e5536b4a8f011b4a83d497b65b1fc4e368c4dd8efb56a1fa4f5aa77381b8f"
    sha256 arm64_linux:   "bcada33c00f3990a99e4b001339dd1d2c85edf49de0698b6ca84028955ba6f25"
    sha256 x86_64_linux:  "ebe1141fac167e85e94bdaa6b33f130e46c2f9e5a47012228feac35c997e39aa"
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
