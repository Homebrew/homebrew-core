class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.0.tar.xz"
  sha256 "62959f791e8e8442f8c13cedac8c4919d78f9120d5bb5301be67a5e53318b4a3"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "9fcb49ad84f965739e207e3d9440a27e1550592d68352803d21c1f9e2ed03ff8"
    sha256 arm64_sonoma:   "2c5bfa2252c66240bba80feeb8bd18f7a88a781e5711bdbea05506d2da4c3099"
    sha256 arm64_ventura:  "96be2a6e6beeb036721afec7dd63dddf4dc147763649379bb4a71deb442f82fe"
    sha256 arm64_monterey: "0ab8e230da6730afc01f483bc6d0ea044eafe2ddf96b9c6e7277c6d879c9a0fd"
    sha256 sonoma:         "0b332a3aa80fd26bd60136d6ac6d4aee215cc1712479c37446e82353e870274f"
    sha256 ventura:        "8ef57fd64b4a9e178484aa20914ed8f9024f0164094849fc4e6009836db403a8"
    sha256 monterey:       "8b2b8cd32dddea8091db82ee6e8d472cd2ea8cd7ce83c5e379c936d721b2675c"
    sha256 x86_64_linux:   "eb146c96d5947c33b35da61fef52f5675cc3e7262247563568e084c6e8806239"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build
  depends_on "vala" => :build

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

    pkg_config_flags = shell_output("pkg-config --cflags --libs libsoup-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
