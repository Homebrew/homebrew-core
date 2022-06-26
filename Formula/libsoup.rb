class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.6.tar.xz"
  sha256 "b45d59f840b9acf9bb45fd45854e3ef672f57e3ab957401c3ad8d7502ac23da6"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "6bfe28dcf8068b439aa91e0961fd296d4acf6e43dc5d9cb5a897d0ecaeda5919"
    sha256 arm64_big_sur:  "d5fa067babffcaf4e70269a7551912fcd1c648adb586737305f83f11afad3afe"
    sha256 monterey:       "58254b69cddd3eb5741aca956a6535248dc4c97d2b4de61560532e3ab18fdecd"
    sha256 big_sur:        "7de9fe1a8f2f25034a015864c936253086df3976138771ea9cf4de8ece311a77"
    sha256 catalina:       "18bf9c45e38b33f303eb474aafd7de7a698a9f27c53501149bc7b1e05664c8af"
    sha256 x86_64_linux:   "fe25656e6d1687571ae712d93e4d9c8f4f78f2381b0a3b6a05349b0a18f013a9"
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
