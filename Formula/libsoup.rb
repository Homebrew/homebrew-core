class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/3.0/libsoup-3.0.5.tar.xz"
  sha256 "f5d143db6830b3825edc2a1c4449d639273b0bfa017a4970871962d9bca22145"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "2ac38804eff5cadd1d4de7c8da500445b5b161609d862e3041987eeb882c358e"
    sha256 arm64_big_sur:  "60991db26c758b2ac94fe9cde1422e3e613e2c762ce264ec8c9dda4d56a9bf43"
    sha256 monterey:       "26b8659ce87110baf75e48e7f5cb400c5d0622bb530ab3d4a1c4d666f7ecd877"
    sha256 big_sur:        "2c24295e3f7fede5773f69517c679f491aee433d17a7f047be6d242ba42a4d3e"
    sha256 catalina:       "816e334fac5361c0864b7240c381b4888c8abb8c25558a896076eb8f1c316cd1"
    sha256 x86_64_linux:   "b820cd35cc7028a2dedfcb9de48fd65ae4a5d7fe95583f9cda4d17d7fdbfc2fe"
  end

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
