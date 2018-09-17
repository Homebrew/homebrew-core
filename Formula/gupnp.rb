class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.0/gupnp-1.0.3.tar.xz"
  sha256 "794b162ee566d85eded8c3f3e8c9c99f6b718a6b812d8b56f0c2ed72ac37cbbb"

  bottle do
    cellar :any
    rebuild 1
    sha256 "42609b06fc41288eea51b93cd7f5b1148eb37643487e9e98e0f6843f4427c2d2" => :mojave
    sha256 "7e27871e73f36e0a957dc59f591aa09972471cc8c3a25e7994735382e2f02daa" => :high_sierra
    sha256 "b7e235858bce8ebc12d6f4c61a2506c6cf6fefd2ffdea083a0c474486374be6c" => :sierra
    sha256 "3382f7c4a3b884bb604179f554d55e31028e40ba97c031fc29c4284ac8c4c19f" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"gupnp-binding-tool", "--help"
    (testpath/"test.c").write <<~EOS
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
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-1.0",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}",
           "-lglib-2.0", "-lgobject-2.0",
           "-I#{Formula["libsoup"].opt_include}/libsoup-2.4",
           "-I#{MacOS.sdk_path}/usr/include/libxml2",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
