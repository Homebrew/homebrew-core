class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.3.tar.xz"
  sha256 "b7f1bbaeeb43f5812daba3ee258a72e1b4b14c2fd91f4a1a75d4eea10dcf288f"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "c3ade9e20bf3ea03797a318d07ef8fc8206c6b6847252068f97949e24b230828"
    sha256 arm64_ventura:  "bbd63967797a9e2cb8e6bf2ded17e4ceca55ecdc2f0081b36e98ec7d4d9ea6be"
    sha256 arm64_monterey: "fde5a1b7198294423a38b7dc3315f94a23e809f050aa2a2b78378f1a35de7684"
    sha256 arm64_big_sur:  "1ed93a0e32c9a10583123991e26fb25d62bd6b6d695d8efd72f289bdd62655c4"
    sha256 sonoma:         "11176fcfd4a989c00771a6fed73792aaf0af9fe6a42c17f09206fdbd461e074a"
    sha256 ventura:        "49f11b9e9da31be090fd8d93cdc644fe481fe9de01fc4d8722f1774d8a195f19"
    sha256 monterey:       "f88bb6ed28ef15bafdefaf8fd24cfb03ff7bac2509596d0f2b51adf15233cd12"
    sha256 big_sur:        "a42d3dbe8e4a21e9e04c084f616dce7fcdbab0b313c5a602991228e55e7994f7"
    sha256 x86_64_linux:   "189e4c090c0abc6f1db514725e0ca84a21894b88ff8293bf75f85d2452070a21"
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
