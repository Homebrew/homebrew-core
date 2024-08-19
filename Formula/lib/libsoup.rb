class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.4.tar.xz"
  sha256 "291c67725f36ed90ea43efff25064b69c5a2d1981488477c05c481a3b4b0c5aa"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "df1cb8af129b82f0ab5d96628ea7caf87ade46e9ef9bf6c579da87e510ce46b7"
    sha256 arm64_ventura:  "b7f355256762b236b6d4fcff8fb5a80049519d99714e3bf051e62c9dac1b519a"
    sha256 arm64_monterey: "15a0f712603d4b6df25ad49558388335362ffd421302c80337a7371529a2bcaf"
    sha256 sonoma:         "dbf3dfe5cb28b449d24773caa726f8dfc8e5be50106e838a40b5c391ffd1309b"
    sha256 ventura:        "ccfb7aa97121d72d9fa0ac050df3d8022410433b8b543000593928912e119ae5"
    sha256 monterey:       "0882c7581ef56bea324c6ca57ede71822ddd6bce9e6ce828c376b2d9dc2ae9a3"
    sha256 x86_64_linux:   "6f5b3e5587f4155be4f50f8c219e0036c116db0aa90c4fc2f24694637a67857b"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "vala" => :build
  depends_on "icu4c" => :test

  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libnghttp2"
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

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libsoup-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
