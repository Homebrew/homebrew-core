class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.8/libsoup-3.8.1.tar.xz"
  sha256 "5013dcef9136f6f861e6529fca578af50c1f52a39219027fb5aff652d1371a04"
  license "LGPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256               arm64_golden_gate: "9972898e51d4ce692eeb5a7c782e784251bff824cbaf19572d214ed3c7099a83"
    sha256               arm64_tahoe:       "9d8674786ce145b207a0c8b4205bd1d698efc4187f96369bb477fd1098748b75"
    sha256               arm64_sequoia:     "9c89d18ef67af64d64f50233ca81116beca8c3dfd528c90f442c96da45e508cf"
    sha256 cellar: :any, arm64_linux:       "52e8e0ce0fe7cb8b5b9392637fff233d0ba1a582472bcc4dfae0c81cf34312ba"
    sha256 cellar: :any, x86_64_linux:      "e611c826cdd8b56e06a28aa8e79a5fe4a1c8a0b11fef9c28e68d29699085d740"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking" => :no_linkage
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

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
    C

    flags = shell_output("pkgconf --cflags --libs libsoup-3.0").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
