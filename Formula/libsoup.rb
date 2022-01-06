class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.4.tar.xz"
  sha256 "5bd38b5e091f707fd7fa3ed7c37aacca3f8e16c65787f1cc17dc38d1dcde567b"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "b73ca7258499aaa0cd75add9db34634541b2a12101066b05f351a934f69f1757"
    sha256 monterey:      "5aff6766a3c3e231cc3aba7285c6962d7adce98c36810d357dcf14f80a3951c0"
    sha256 big_sur:       "e3544f972f498a9dc55e780a7774ffc694b422ed8ca2c28a6b33de31937f8d6a"
    sha256 catalina:      "412d8fe244d90a4e8115368318b9004d12c6d73d4565b1a3c2c7a50901b1dd0b"
    sha256 x86_64_linux:  "f8a669774202cb044c1c02832595bf0e178a0b1bb09f8b3848482977be14d96f"
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
