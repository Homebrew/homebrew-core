class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.2/libsoup-3.2.1.tar.xz"
  sha256 "b1eb3d2c3be49fbbd051a71f6532c9626bcecea69783190690cd7e4dfdf28f29"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "a44f2f0440b391e5d5fb38b311a889994783d3c85cc142af0d7eac67a81bfa89"
    sha256 arm64_big_sur:  "dd5d63558649d575cd94ba51a1d8f4b8db3f7671d4b247eb3e51acc93794127a"
    sha256 monterey:       "d980c8f45a3e3aba0075971d77f53c9d215c2df225d2212351f17f14e9a0ee8f"
    sha256 big_sur:        "a964f9568534f6afb8f918855be5f1fee2e01a8824e07e2ecb1f45a1f5e6abc1"
    sha256 catalina:       "0e7b5028ea9a2c9ff55852e8c0a6e8a2264cfe014de6874b0f71ced26a412bf5"
    sha256 x86_64_linux:   "90a282d3c0423432a8c6fdd4b0121853aca574b47dfd7dd57bf537a653a6ba39"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
