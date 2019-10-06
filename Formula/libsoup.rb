class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.68/libsoup-2.68.1.tar.xz"
  sha256 "7f0323e53b8e797baa972dfe25adf3cc6ceff06f0a26235b6c5c7b91403fbf8d"

  bottle do
    sha256 "d882f0bce9df60a460a82b061dfe0a0c66789e7780cb54f34f767ecf07e8b479" => :catalina
    sha256 "b4429e97c22d16241ebfdbf73ba9762a8c1a212ea3f1e3b2f1393f2596387e6d" => :mojave
    sha256 "ad0699c4777b0d8c3fe97d7acdb976f3f1476eb91668eb7d892aef7c21f1c778" => :high_sierra
    sha256 "c0556c4e10da84df18ae1f4a08144c5349dca7df1f8e4fd4cbbe59a7d4248cec" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "vala"

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
