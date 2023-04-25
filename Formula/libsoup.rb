class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.1.tar.xz"
  sha256 "530b867b1b166cb9bca2750f1d15e5187318b5d948efb81d5899af3d75614504"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "bff3499b52d37e8157bad9cfa7a3adc99304efe1a4d8ae8f338c222c99e991ed"
    sha256 arm64_monterey: "dc4f4dbf5ccbcc6fe1090f5f00610fae055f4b0c923a2204c47f3ddca61cc480"
    sha256 arm64_big_sur:  "126947de5d4c6c5eb8ed86aaaed544bd5c1ae1c6bdbf75c79ce57de92b07cde8"
    sha256 ventura:        "89d5cd114db49e39fb0e093154ae6b86f32e2ec4643125bbcc5c28faf036e965"
    sha256 monterey:       "64045efd4319fe83a4c5e671a4d0288cefbd2b5a5848fdd11848843ca5c1012c"
    sha256 big_sur:        "38f649ac745aead0589526a2caa4242052f2853ac314a599893372693382969b"
    sha256 x86_64_linux:   "4b40d10f34fbabb0a3a67d8f12820b5a0e313a5fc6876fcc2ebc0066b2f42619"
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
