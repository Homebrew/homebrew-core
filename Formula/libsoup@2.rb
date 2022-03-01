class LibsoupAT2 < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.74/libsoup-2.74.2.tar.xz"
  sha256 "f0a427656e5fe19e1df71c107e88dfa1b2e673c25c547b7823b6018b40d01159"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "b2c190abf51f79ced1d8d8eda2a5db31a5aefd9314c617db794d186cf52f16bf"
    sha256 arm64_big_sur:  "65d616e5576bba08deb1eff22b926d7d35fb7209e92266078f28bf21caa150c7"
    sha256 monterey:       "f34c69d8b128305d2e4956bac273011c093987c7168cb73ab1e6bb825e3f7451"
    sha256 big_sur:        "19a9b6667489787eccde03fee2cc88ed85d65164da35d22c23774a518ffb8459"
    sha256 catalina:       "0debe8befca52517e4eaa1c9d14cdf70f534d2dc06ab67738263b6e0e3593df5"
    sha256 x86_64_linux:   "bd41af9c5e451ccda79c5f24bde318f2e370b53b86bebe6a59dd62abfac2e07c"
  end

  keg_only :versioned_formula

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"

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
