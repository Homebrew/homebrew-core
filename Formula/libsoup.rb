class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.64/libsoup-2.64.2.tar.xz"
  sha256 "75ddc194a5b1d6f25033bb9d355f04bfe5c03e0e1c71ed0774104457b3a786c6"

  bottle do
    sha256 "b53e3d934346b9329aa0bbaca1497a6da9dd04bd2ad7a1933a9faa11bcb2369d" => :mojave
    sha256 "47635a7b40764b64daf4e8f6ebfc0a44f4be4acc14a07f27b95a8b20efbe30b8" => :high_sierra
    sha256 "c46b8de3d6e603a73fc78f5ec338a69d3f96d73e3e9917e694c954eb26cf3caf" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "vala"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-tls-check
      --enable-introspection=yes
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in",
              "VAPIDIR = @VAPIDIR@",
              "VAPIDIR = @datadir@/vala/vapi"

    system "./configure", *args
    system "make", "install"
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~EOS
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        SoupMessage *msg = soup_message_new("GET", "https://brew.sh");
        SoupSession *session = soup_session_new();
        soup_session_send_message(session, msg); // blocks
        g_assert_true(SOUP_STATUS_IS_SUCCESSFUL(msg->status_code));
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
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
