class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.3.tar.xz"
  sha256 "e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "93cc36e0aca55d8d3ad613e40d4c4f870792d544472236eaa4e2007e8bdccdd7"
    sha256 arm64_sonoma:  "30cc853c0df1b294a5bb54f4224c01892dd8a227eef2b2f9db4525ee5660dda3"
    sha256 arm64_ventura: "2a309b1eccf23b179e5812c98df8d8fcb377cf5af35dd1e3cd4c88e23d1fa852"
    sha256 sonoma:        "10bcbb15d4a0c105a32894d3211d54a57a69e16296ccd59e6374002c33be6bb2"
    sha256 ventura:       "848cd63411742567dad48774cd56f9f3d2091a115e2a9cc803021af250e91c6f"
    sha256 arm64_linux:   "f894a1f3fae10a780ec0a489cc4c84636f792c6013337c3d07f50e6af02303a2"
    sha256 x86_64_linux:  "128d3fa437db9352c8c33b6937083fbb708ddd23566b957b243e9cee2debab16"
  end

  keg_only :versioned_formula

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.13" => :build
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

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
    (testpath/"test.c").write <<~C
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
    C

    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs libsoup-2.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
