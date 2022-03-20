class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.5.tar.xz"
  sha256 "f5d143db6830b3825edc2a1c4449d639273b0bfa017a4970871962d9bca22145"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "00f0ccc50096a530185d14d5bada1a48d234319f062a3b47ad11ce7a206b7525"
    sha256 arm64_big_sur:  "c31195b9f005e30518dc4af8e2427c0bab9bef379055cfb41a3e03fb782f2926"
    sha256 monterey:       "a0a48979bad7c9d5a4a51b7ae4b8c7a57a5c2bd0b0320cac1bb47be4b99bab0d"
    sha256 big_sur:        "25fc68c4ee56e740fa16757534495a3e3ae286479884d6a5ca1dc28648b5eab4"
    sha256 catalina:       "ba3aa24bb077b937bcc71a60c0530747435150234e8061b5ec9ae35a2eb7e029"
    sha256 x86_64_linux:   "b9e11ac204af63538f4abf34e5b3ea4303f7e0567d1d87e55fc7a7572ecb8578"
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
