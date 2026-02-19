class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.3.tar.xz"
  sha256 "e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13"
  license "LGPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3843052f79eaa80401b387d1a0c3092c87530d4d3b8990c62a850be37e70c379"
    sha256 arm64_sequoia: "5daa9270adbc44160747bb08e6c50b61e1421582474480ab35a23cf8d20746fc"
    sha256 arm64_sonoma:  "a6c52b69c5d790f34cabf7b34ea5c01e80d3a6bdd29b54a2f02fc0f2e1dee285"
    sha256 sonoma:        "566098c112e98e00992026a2b2677e680a533244359928df662481f81c9005a4"
    sha256 arm64_linux:   "918e532c5ecdf26f5f4c4c5ceda05389eb372712282b78d8876eafd16511a321"
    sha256 x86_64_linux:  "e202649ae1fcd94d595ca68f9913e025827be307218eb61b9ca7586fb1495f57"
  end

  keg_only :versioned_formula

  # 2.74.3 has CVEs. Some backports in branch[^1] but no plans for another
  # release and only usage of `libsoup@2` is unmaintained `libgdata`.
  # [^1]: https://gitlab.gnome.org/GNOME/libsoup/-/merge_requests/449
  deprecate! date: "2025-09-05", because: :unsupported

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
