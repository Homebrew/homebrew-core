class Librm < Formula
  desc "Router Manager Library for FRITZ!Box Router"
  homepage "https://www.tabos.org"
  url "https://gitlab.com/tabos/librm/-/archive/2.2.1/librm-2.2.1.tar.bz2"
  sha256 "9175de95a5049844556351bfd0c82fa51b31256f207d3b4782c530d3ae910c3b"
  license "LGPL-2.1-only"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "capi20"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "gtk-mac-integration"
  depends_on "gupnp"
  depends_on "json-glib"
  depends_on "libsndfile"
  depends_on "libsoup"
  depends_on "spandsp"
  depends_on "speex"

  def install
    args = %W[
      --prefix=#{prefix}
      -Denable-post-install=false
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja"
      system "ninja", "install"
    end

    # meson-internal gives wrong install_names for dylibs due to their unusual installation location
    # create softlinks to fix
    ln_s Dir.glob("#{lib}/rm/*dylib"), lib
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glib.h>
      #include <rm/rm.h>
      int main() {
        gchar *result = rm_number_scramble("012345678");
        g_assert_cmpstr(result, ==, "01XXXXXX8");
        g_free(result);
        return 0;
      }
    EOS
    gdk_pixbuf = Formula["gdk-pixbuf"]
    glib = Formula["glib"]
    libsoup = Formula["libsoup"]
    flags = %W[
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libsoup.opt_include}/libsoup-2.4
      -L#{gdk_pixbuf.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgdk_pixbuf-2.0
      -lglib-2.0
      -lrm
    ]
    system ENV.cc, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
