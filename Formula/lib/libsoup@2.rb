class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.2.tar.xz"
  sha256 "f0a427656e5fe19e1df71c107e88dfa1b2e673c25c547b7823b6018b40d01159"
  license "LGPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "9d50f2ce85396610a34a8b73c2f90f065a61958f5b5aa5f31df1a5e6d1c6b901"
    sha256 arm64_ventura:  "b6b1f722faecc11f7f0f7d59da96b6582815179e2998e06c9d7d9a9b6221b8bc"
    sha256 arm64_monterey: "c9a5a1b8cdbad59ea9bb297e382dd1165a3ada3d8145f4da3cec8183c34be647"
    sha256 sonoma:         "df99ce0eca58f54c20982f095d6b0d51904dbfe21451e92637ba8b506c81cc4a"
    sha256 ventura:        "9ff691ca203a1692efc87a66bb3f162eb88680a931085accbb65e223209e4704"
    sha256 monterey:       "83efcf8f54f047a9ba3dd3acf032ef4cdbabce4574feac8105e6ae3822878021"
    sha256 x86_64_linux:   "416f1242c8f4e786d4e3fb673a40926b9c5543bf50420bf9dbf24cae569743f2"
  end

  keg_only :versioned_formula

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
        SoupMessage *msg = soup_message_new("GET", "https://brew.sh");
        SoupSession *session = soup_session_new();
        soup_session_send_message(session, msg); // blocks
        g_assert_true(SOUP_STATUS_IS_SUCCESSFUL(msg->status_code));
        g_object_unref(msg);
        g_object_unref(session);
        return 0;
      }
    EOS

    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
    pkg_config_flags = shell_output("pkg-config --cflags --libs libsoup-2.4").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end
