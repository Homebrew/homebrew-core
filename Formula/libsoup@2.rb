class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.2.tar.xz"
  sha256 "f0a427656e5fe19e1df71c107e88dfa1b2e673c25c547b7823b6018b40d01159"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "f237e2e3e6d4ed0ee7a3945803a0353afa7d140f9da9c86adbdf3e6e6462f942"
    sha256 arm64_big_sur:  "5b1b9dade41e9ac5bace93b5a5b240215ccddd066eab199d99e63268a9b78134"
    sha256 monterey:       "147797ede82518930df4c67e9d6b7d1657df9a86e22f7e9fbf0913fc7d7160bd"
    sha256 big_sur:        "ae93e296368952c101e3f1c73f8e4ffecd7fe33a1a147eb4fe0c3133153e4656"
    sha256 catalina:       "a6dd84f233c015ef8015188b22ff20d55eb23e334c6a2387b6adfc309f508020"
    sha256 x86_64_linux:   "e8c68f3306949fc841a97897aa79840a2cd72ab06217aaf8cfe787129cae623f"
  end

  keg_only :versioned_formula

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
