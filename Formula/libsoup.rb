class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.0.tar.xz"
  sha256 "23efff6ac70f2c1e873507dac52649eec032c1597a4ae951762ce3123789acc9"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "9b47a9e8ebf10768f77650894179965a78fcb77a5c5a77c5f0c61cea237dc93a"
    sha256 arm64_monterey: "f308af58a4684ed751f8253b044cd5ae968e396516db7249a19b435c4d412f36"
    sha256 arm64_big_sur:  "9956f02631a1b35866052aef5ee2b618fda61e0455cf48d2f5a9856df7b0e0f2"
    sha256 ventura:        "9ea071bd6fc47760196ab01060e9761e3de57a920506d85cfa3c0f76ad32bc40"
    sha256 monterey:       "d3195cf49836242d3519d2bd2513d7114f75bc5644bfe535e22cc18e8b53b125"
    sha256 big_sur:        "64fc912450bf078a42ad5ad664ff8218f5591876f50d95735924dd4c8d998973"
    sha256 x86_64_linux:   "bf75c9b6c8e005da9e04353a1443fd496703b838bf0dea1a162b605aacdb427f"
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
