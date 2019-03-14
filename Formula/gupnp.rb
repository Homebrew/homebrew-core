class Gupnp < Formula
  desc "Framework for creating UPnP devices and control points"
  homepage "https://wiki.gnome.org/Projects/GUPnP"
  url "https://download.gnome.org/sources/gupnp/1.2/gupnp-1.2.0.tar.xz"
  sha256 "fd74a2c236f3dbe6f403405cecfd0632a14c7888a0f6c679da5eefb8c2a62124"

  bottle do
    cellar :any
    rebuild 1
    sha256 "42609b06fc41288eea51b93cd7f5b1148eb37643487e9e98e0f6843f4427c2d2" => :mojave
    sha256 "7e27871e73f36e0a957dc59f591aa09972471cc8c3a25e7994735382e2f02daa" => :high_sierra
    sha256 "b7e235858bce8ebc12d6f4c61a2506c6cf6fefd2ffdea083a0c474486374be6c" => :sierra
    sha256 "3382f7c4a3b884bb604179f554d55e31028e40ba97c031fc29c4284ac8c4c19f" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gssdp"
  depends_on "libsoup"

  # submitted upstream as https://gitlab.gnome.org/GNOME/gupnp/merge_requests/3
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end

    # to be removed when https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222 is fixed
    inreplace share/"gir-1.0/GUPnP-1.2.gir", "@rpath", lib.to_s
    system "g-ir-compiler", "--output=#{lib}/girepository-1.0/GUPnP-1.2.typelib", share/"gir-1.0/GUPnP-1.2.gir"
  end

  test do
    system bin/"gupnp-binding-tool-1.2", "--help"
    (testpath/"test.c").write <<~EOS
      #include <libgupnp/gupnp-control-point.h>

      static GMainLoop *main_loop;

      int main (int argc, char **argv)
      {
        GUPnPContext *context;
        GUPnPControlPoint *cp;

        context = gupnp_context_new (NULL, 0, NULL);
        cp = gupnp_control_point_new
          (context, "urn:schemas-upnp-org:service:WANIPConnection:1");

        main_loop = g_main_loop_new (NULL, FALSE);
        g_main_loop_unref (main_loop);
        g_object_unref (cp);
        g_object_unref (context);

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/gupnp-1.2", "-L#{lib}", "-lgupnp-1.2",
           "-I#{Formula["gssdp"].opt_include}/gssdp-1.2",
           "-L#{Formula["gssdp"].opt_lib}", "-lgssdp-1.2",
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

__END__
diff --git a/libgupnp/meson.build b/libgupnp/meson.build
index b832acb..561b3cd 100644
--- a/libgupnp/meson.build
+++ b/libgupnp/meson.build
@@ -90,10 +90,20 @@ sources = files(
     'xml-util.c'
 )

+version = '0.0.0'
+version_arr = version.split('.')
+major_version = version_arr[0].to_int()
+minor_version = version_arr[1].to_int()
+micro_version = version_arr[2].to_int()
+current = major_version + minor_version + 1
+interface_age = micro_version
+darwin_versions = [current, '@0@.@1@'.format(current, interface_age)]
+
 libgupnp = library(
     'gupnp-1.2',
     sources + context_manager_impl + enums,
-    version : '0.0.0',
+    version : version,
+    darwin_versions : darwin_versions,
     dependencies : dependencies + system_deps,
     c_args : context_manager_args,
     include_directories: include_directories('..'),
diff --git a/meson.build b/meson.build
index 9cf4697..45fb0dc 100644
--- a/meson.build
+++ b/meson.build
@@ -1,4 +1,4 @@
-project('gupnp', 'c', version : '1.2.0')
+project('gupnp', 'c', version : '1.2.0', meson_version : '>= 0.48.0')
 gnome = import('gnome')
 pkg = import('pkgconfig')
