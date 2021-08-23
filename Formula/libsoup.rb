class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.0.tar.xz"
  sha256 "33b1d4e0d639456c675c227877e94a8078d731233e2d57689c11abcef7d3c48e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "4ba31ecd333f8be6a5cb4eed23715fce9b478d79345bf51b88e172a2db0fb496"
    sha256 big_sur:       "b135c1b3cf8a49f15afdb9d7c354b9175de2561c20a3e4ef8b91a8234f81fbe3"
    sha256 catalina:      "b7f09cfabd4ef0210d181e54e74f2cff33518df0c81bc9e27764454e54cb6243"
    sha256 mojave:        "14a5f08043cacb9f68a9f5d48e0175397c81184621fbcbec871aa764241509a6"
    sha256 high_sierra:   "78a481740fc494934fdbafbd25f8c7141f57cd61d1ff713682fe3a5a4b91b840"
    sha256 x86_64_linux:  "7c34d7c7d910a7d6e7ad7ede27fac2370cb1961c26b75779a540db4bae972bb4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "vala"

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
