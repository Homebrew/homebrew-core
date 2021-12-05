class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.3.tar.xz"
  sha256 "5165b04dadae3027e9a2882d868694b4586affd778c194982ae4de2373d2e25e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "e1d69a9438c85ffd4f3a8053a793bd7c0bc1549854a15647323a548af9e89512"
    sha256 monterey:      "054c4eb1f108323999d2582d2a19ccf4e09eab6612c6f55fb7f983ff3536337f"
    sha256 big_sur:       "3c9dcd7ceae483d7492f7078d324b7d4c3beb67f7683b71fadf9d50f6c6809c0"
    sha256 catalina:      "2dbaf27a1f72fd3d4cad39ec405d892d02a1d4e0b4107cf7af5d1eaad81f8f71"
    sha256 x86_64_linux:  "b673fd74270840cbb437b3b44441eaae3a77284e57cfc7b86cb65f03b489ca31"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~EOS
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
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-3.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-3.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
