class GupnpAv < Formula
  desc "Library to help implement UPnP A/V profiles"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gupnp-av/0.14/gupnp-av-0.14.3.tar.xz"
  sha256 "abe2046043e66a9529365d89059be12219c21a4ede0c4743703b0fd9aaf17bb4"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "52e96af2014c55ac944a7a12ce3983a51fb4d67b1476bab9c197511eb26f17d4"
    sha256 arm64_sonoma:  "f5fa71cfa4de6c5d2eb41b3481035b601b9346002d2e0314d2b475414e293a67"
    sha256 arm64_ventura: "4ac0ba69dc914ac64f6dfb684499e3da9d4b0ca15745b362cc20dfb7b5832075"
    sha256 sonoma:        "bed183c138c06172f184183d91dc750a20c53e35ddfdc5edef3e3562f5643cd7"
    sha256 ventura:       "10dfe0149fcc7e18fb487e427ccb69d8dbc7cd88c96c8ad1045eef7690ea2a77"
    sha256 arm64_linux:   "09905f96300d4ebc606466615ceca173a6fe4807e916d600df67692f9b3a0cd7"
    sha256 x86_64_linux:  "e130c48d351f4491f7c9a5ed5ca73510edf4fdfdadb33186e966e0650d73bac6"
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
