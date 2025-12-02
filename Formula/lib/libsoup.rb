class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.5.tar.xz"
  sha256 "6891765aac3e949017945c3eaebd8cc8216df772456dc9f460976fbdb7ada234"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "74618fb6f2ecb96b9c7080d4cb270c46ac547196e08982bff59b8f7796b5ab5b"
    sha256 arm64_sequoia: "9347047d84f194d6079f4a42bd07a493182bff757bcd099498d344f608996b68"
    sha256 arm64_sonoma:  "3524cbb252af5c9cc9b39cb0ff9733d2130be70e264339c926189564c121b82d"
    sha256 arm64_ventura: "7af02d6ee61baf7463f21b0261430cccb10bc72102a3bad27be16c5f74173c57"
    sha256 sonoma:        "3be670d505dedb3a71e0b9617e4c0b8096cafcf70486a3657c38f02f0502f28e"
    sha256 ventura:       "430c7a028fbcc2239b1213faec338814bf055c037a4cfc22828a0ab3e3edc245"
    sha256 arm64_linux:   "dc576162b656fc666022b3a276dda763823e13fed31e7da72b5189602460f2da"
    sha256 x86_64_linux:  "426c2decb12e1fc035d9f50477a173fa04625cd1e3895dbf04cecce15aefe3a3"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking" => :no_linkage
  depends_on "gnutls"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"
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
