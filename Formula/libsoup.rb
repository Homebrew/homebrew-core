class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.7.tar.xz"
  sha256 "ebdf90cf3599c11acbb6818a9d9e3fc9d2c68e56eb829b93962972683e1bf7c8"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "3a65a35c6dfa623e09f5b36d098445e215871ec09d0a3ed18b5bd25b05e452fd"
    sha256 arm64_big_sur:  "a90ecc9dc9b6172189d9f748a3d7bb19bbd826d9f457bd617db49200470637fa"
    sha256 monterey:       "40baff4cb1af532c52cc26714a5fc57315f4d120612cef73e97efd2965c077bd"
    sha256 big_sur:        "201612adc949ca409beca80f2830c6984d6dd13d9cc6f36d5472662af573f489"
    sha256 catalina:       "0e5daf91cd10e169a35bc821675e438b331ed3f1092f2abafc461d564be85fa3"
    sha256 x86_64_linux:   "865315a09372ab22d48f15bef518e54fdd69493dae309bca6f8816206c948834"
  end

  depends_on "glib-utils" => :build
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
