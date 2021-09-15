class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.0.tar.xz"
  sha256 "33b1d4e0d639456c675c227877e94a8078d731233e2d57689c11abcef7d3c48e"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "e7c59cf457c9f3d13dcd9f0d101b82a1fb9b446c31d4b88986822998f97a0c98"
    sha256 big_sur:       "75b7a97c03c5eb93b5fa612d53189e35bc92d9455fdedf85e885a516c43f932e"
    sha256 catalina:      "255b10e650d1c4892fb37643efe9e57c578d565a26ca024d14fa773bf067ff1c"
    sha256 mojave:        "910b60a2602e8aab51bf9162590c6f28c34de1efab02c50549d4c41b0adbc106"
    sha256 x86_64_linux:  "64e4b60673a0e428c261a715fffd9bfbca1798c3254f31f9ac80e591c2a53f57"
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
