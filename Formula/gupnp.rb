class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.0/gupnp-1.0.2.tar.xz"
  sha256 "5173fda779111c6b01cd4a5e41b594322be9d04f8c74d3361f0a0c2069c77610"

  bottle do
    sha256 "28afff235b826e62bfd7133394b91a4b3746c3bf591efb5eb35767978e6e5f9a" => :sierra
    sha256 "122ab1bd5cd7864e3ba5e8242d62fc4d1a46fe3827801751c967c4877958a19d" => :el_capitan
    sha256 "c75c47821df5392618b6ce7f438f509e5c6833fe7f60f6657b3081adf537da37" => :yosemite
  end

  head do
    url "https://github.com/GNOME/gupnp.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "gssdp"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    if build.head?
      ENV.append "CFLAGS", "-I/usr/include/uuid"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"gupnp-binding-tool", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gupnp-1.0", "-L#{lib}", "-lgupnp-1.0",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.0",
           "-I#{Formula["gssdp"].opt_lib}", "-lgssdp-1.0",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I/usr/include/libxml2",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
