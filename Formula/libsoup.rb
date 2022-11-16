class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.2/libsoup-3.2.2.tar.xz"
  sha256 "83673c685b910fb7d39f1f28eee5afbefb71c05798fc350ac3bf1b885e1efaa1"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "c571c60ad09c0c6e6c272c5ddcfdabf85ea3e3bbce93161100d6c71e446f5aee"
    sha256 arm64_monterey: "b22b09d52e079b8d0e2325d54add7724a9f2cf218357b08b426983906cf22d5d"
    sha256 arm64_big_sur:  "a9695ff8bdf87ff6bfe9836cf8732c414b46b5c1006b4510a78a7e880313609a"
    sha256 ventura:        "8367c6b317f10c9c1c5958c50b70a5c0e54347b15758a684e3f722d40d18d3ca"
    sha256 monterey:       "d3c9776e1c362071d86696f7b4b56edd03f2a010dfbe30ca22f38fa240133ccc"
    sha256 big_sur:        "55c7ef19cad510057eae06943c05f5f918b4c42618e203c54ee6b39d4da10819"
    sha256 catalina:       "6affbc54541538fa0e5192a9f99f6cda86f66e2f8c2fd0ac2e69fdae8dacae6c"
    sha256 x86_64_linux:   "4939236918b6c980016d721e4156e33bbe5bc3a8cb76b37751ad73c99d75776e"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "vala" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

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
