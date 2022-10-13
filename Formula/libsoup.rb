class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.2/libsoup-3.2.1.tar.xz"
  sha256 "b1eb3d2c3be49fbbd051a71f6532c9626bcecea69783190690cd7e4dfdf28f29"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "63b130e3b034b064045188c9aba3faf95e486e16423f716bacd73cb1785d2b91"
    sha256 arm64_big_sur:  "1ba65f4fbeacf5e6738449535e70407d0346057248ac2a71228cec09bad1412e"
    sha256 monterey:       "1bb0ece234967f67d36a1faca80e77d3ae0e483caea1855d3fd9e854d2b11cb6"
    sha256 big_sur:        "4dac0cafc02be9a6bad901c3b7f2da1a0807230ae60f0e32c9be2f26eee698f6"
    sha256 catalina:       "666cabe456ca81206b49adce3cc1e87d8f04edc21876a2a39b970771f24d22b8"
    sha256 x86_64_linux:   "b281c27e0ba37d2e763185431cc1fa94cae5c67675e91d3cd1063e6241bc6a96"
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
