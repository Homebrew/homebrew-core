class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.8.tar.xz"
  sha256 "c8739dc1c23c2b1e3b816d7598b3fa1764a3e1a2a2f5257b1bc4466d867caced"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "ce9be7a6430e5ad4130b5119695c18fca50ceeaa4b48e2070e086e5671b2b906"
    sha256 arm64_big_sur:  "fade8aa78c7d30d257cacac998c3fcf5a9ed2f23e9eb8650bb0bbdf75c1dc781"
    sha256 monterey:       "d6c2693071efd9ae4ebdc8c238af301e1a304214a14de6b7219fce94703b677c"
    sha256 big_sur:        "70466230085dee25a369684a2739b26553bf849a30faeea47b44d8a40d4d62f0"
    sha256 catalina:       "f7cd4fd0f05050c24dc2d1bce7a9074417d1ec8ff5ed6272a8574e860bfdadcc"
    sha256 x86_64_linux:   "f05deaf1f0ffb5404a40160e7042a68d3008af7468861cdbffe8f7f4e0181ae0"
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
