class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.3.tar.xz"
  sha256 "e4b77c41cfc4c8c5a035fcdc320c7bc6cfb75ef7c5a034153df1413fa1d92f13"
  license "LGPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "8d0b9024c71c3dedf27463fb24861679a4c1e462c32dba678eae3b233784e5da"
    sha256 arm64_sequoia: "ec4bd5e3db72b68f217650bdb80f3640649624fc7e45f2da67113061dffbb570"
    sha256 arm64_sonoma:  "1563ef4a32d45d51a7b5c5fff98f5c74f4f15f4e2d30bc43754e5865ca422dc1"
    sha256 sonoma:        "f335f613fdb50f36e0f75aa005d829a3494b523c5d27f70b000b291fe32cfa4d"
    sha256 arm64_linux:   "b08fb4563a62d3b610014e5a6f4e6f0cea0680075ed0c7bbe1d89644585d004c"
    sha256 x86_64_linux:  "0b6fec65bf0c66eaac516a655954a9dbbe86f51e4517872732937ded648ccdd5"
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
