class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.2.tar.xz"
  sha256 "78c8fa37cb152d40ec8c4a148d6155e2f6947f3f1602a7cda3a31ad40f5ee2f3"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "7364c4e47eea24b6ea67db78d83815ae4c9e2f8bdea0e8d4a0dea40350e0245c"
    sha256 arm64_monterey: "bdb31462cdf23d34daeada8ccc6e1edbd5c4836ac7daab0e93b8a060643e6a45"
    sha256 arm64_big_sur:  "67ec4c878265ca35fa502455625450b25a19a862993de656ad156b6c7ba1192f"
    sha256 ventura:        "1f3458517efe283f12cb59cc30ade2aa3c9d725774c53354c61f273f57d3cd33"
    sha256 monterey:       "518ca7b67460550fd71f19c1f0cf52e3524c4dc4d6b14830ab0127c7db665bfd"
    sha256 big_sur:        "8592dfba0eea66d9c36bea2e73f0cdf3ee53b909fa8e1681db8c18b3dd9eab42"
    sha256 x86_64_linux:   "d4475a310a89f648f50a4eaee7fcd451115fcbb97c41cf95f20d262bc6cf97fb"
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
