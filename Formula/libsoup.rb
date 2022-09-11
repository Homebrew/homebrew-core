class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.1/libsoup-3.1.4.tar.xz"
  sha256 "0415993fc99746bb0fca9549004a828080b1b936213540f297c290059570b554"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "a3921bec5cde8f68b4e18492337a5592379ee9be85ff0bfa8ecc45c725be92f2"
    sha256 arm64_big_sur:  "fbbb6b0ba2c9f4c42d859d957c52bb6baadef1469132c544c537dbc3f829317a"
    sha256 monterey:       "35f72679633da06f56ff80d31314be823478dc35a168eaaea54123cb7e04e9c9"
    sha256 big_sur:        "74663f81f1ddabfeecd8bd0190a651c38cbe3b40864e93511c1889dc8e238fd6"
    sha256 catalina:       "1fcb359924843a0937cd01064c6bbf5a47f817968a5f172f11ea97c026a832de"
    sha256 x86_64_linux:   "19f1fe4e6fa9857b60f084801ff15a5caa3aba2c696130751783b8bd47bd6b84"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "vala" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"

  uses_from_macos "krb5"
  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

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
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-3.0
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-3.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
