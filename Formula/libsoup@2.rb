class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.2.tar.xz"
  sha256 "f0a427656e5fe19e1df71c107e88dfa1b2e673c25c547b7823b6018b40d01159"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    sha256 arm64_ventura:  "28703a1f52485e8606ff0e34b22bcaf09aa743f84b62c937f8e2dc6bb2a3e2e9"
    sha256 arm64_monterey: "c83d1b06c461f1052dca33dbb4611de3255629a01f6841cea10c879b33de062a"
    sha256 arm64_big_sur:  "1beb7bcd38a32eb0392edf2c4512282dd70545a00522abceb18f27e8c4ad0ca1"
    sha256 ventura:        "c75a526b2a7e38e78e1610f943e5057c3f74ee047405005a75e263e502fcc08e"
    sha256 monterey:       "c45af2b51eefcef87380bd327d068113d862d8ea3468798143229e4a6ffaf066"
    sha256 big_sur:        "c5b6becbd8d56922f462b27d995abdfb3c0e0bf40a5f90ad2dbaf8fbcf342f60"
    sha256 catalina:       "a197f1b5e2b63ac86c26398cd4a01c60e5ff6c467fcfd4e64462c5c7d37186e2"
    sha256 x86_64_linux:   "de39b19dac0d2b9ef080286d5402ab4d8d950d21765b19ebc4888276843c9009"
  end

  keg_only :versioned_formula

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
