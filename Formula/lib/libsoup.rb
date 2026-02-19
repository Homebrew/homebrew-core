class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.6/libsoup-3.6.6.tar.xz"
  sha256 "51ed0ae06f9d5a40f401ff459e2e5f652f9a510b7730e1359ee66d14d4872740"
  license "LGPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "5f72f9159dbbe2d66fe9fe9b2dedeacba280390f50d10ff337b35d2343fedf0c"
    sha256 arm64_sequoia: "85f9669848a5936194b531c35fdbc011ad26b856b235ea0aab0386153694cadc"
    sha256 arm64_sonoma:  "1b11895e9bc1ae1cb472689c9fdeec59e306adaa9d572bd5bc60529c0cb82d75"
    sha256 sonoma:        "6829a788855e2989eaa02a3f3cd96f043a8902729d045c9f36f620653c7ef5fd"
    sha256 arm64_linux:   "f90f3792a0ace929f8b719754fa5fac11cb8fa1677f1e64dd50083bc007ed7a6"
    sha256 x86_64_linux:  "7ebfdb0452d9fb68b33bc374afe63441ce9ee387f5b666342a617f1074bbf128"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "glib-networking" => :no_linkage
  depends_on "gnutls"
  depends_on "libnghttp2"
  depends_on "libpsl"
  depends_on "sqlite"

  uses_from_macos "python" => :build
  uses_from_macos "krb5"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "brotli"
    depends_on "zlib-ng-compat"
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
