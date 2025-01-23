class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.4.tar.xz"
  sha256 "9b54c76f5276b05bebcaf2b6c2a141a188fc7bb1d0624eda259dac13a6665c8a"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "bf60be558ca065fcc5297159c6b31fe69b57b6c5feb0e08ec1998ffdbf2c98ab"
    sha256 arm64_sonoma:  "2518220b58936cd3c04a16f9bdaf4f8278ef40a6c4b0db4f1740164688ad357d"
    sha256 arm64_ventura: "81f7b8e7a8e7cd40cd3c0a69f1891c5e0eecbddef81ea165ae15ae21b98b4c91"
    sha256 sonoma:        "92a2c7f8d1355a67928e474a3a08e8d18f82218338bbdfe5f638fa187a3174ee"
    sha256 ventura:       "381dd5caee44bf4ef3163e115c8ec4a5284a4408536c1c23b81febe2f569c932"
    sha256 x86_64_linux:  "9c2efe5aa74545fbcbb593d814e663e920d8e4e484cc735349aff5b1a5bd744b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "brotli"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~C
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        SoupMessage *msg = soup_message_new(SOUP_METHOD_GET, "https://brew.sh");
        SoupSession *session = soup_session_new();
        GError *error = NULL;
        GBytes *bytes = soup_session_send_and_read(session, msg, NULL, &error); // blocks

        if(error) {
          g_error_free(error);
          return 1;
        }

        g_object_unref(msg);
        g_object_unref(session);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libsoup-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
