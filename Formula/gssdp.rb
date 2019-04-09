class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.2/gssdp-1.2.0.tar.xz"
  sha256 "22cbef547f522f0b062933e302482ebdb397e2f3703899757562ddffbbfd00d1"

  bottle do
    sha256 "ba0e685fdd43e1a7077acc89f426094cbac4bbd6ef8a7c9a41c019d51edb48a6" => :mojave
    sha256 "f8ffc61329914be5de59373b9d2aacc7a762bc902730e0202ddf82f1c6cf6186" => :high_sierra
    sha256 "e5e69427ba9125550e2e07d0ce98c02311d9cf21535244b5ea78bd01e8494271" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  # to be removed when next release is out
  patch do
    url "https://gitlab.gnome.org/GNOME/gssdp/commit/3b085a7e2c94119519d848c4f4f1434bbea3d937.patch"
    sha256 "7d9b36c81bbbeca390c417f86e5e287c0ba350350928ec37617b8182db548f9c"
  end

  # submitted upstream as https://gitlab.gnome.org/GNOME/gssdp/merge_requests/2
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dsniffer=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.2
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/libgssdp/meson.build b/libgssdp/meson.build
index aa66def..a022609 100644
--- a/libgssdp/meson.build
+++ b/libgssdp/meson.build
@@ -48,8 +48,18 @@ if generic_unix
   sources += 'gssdp-net-posix.c'
 endif

+version = '0.0.0'
+version_arr = version.split('.')
+major_version = version_arr[0].to_int()
+minor_version = version_arr[1].to_int()
+micro_version = version_arr[2].to_int()
+current = major_version + minor_version + 1
+interface_age = micro_version
+darwin_versions = [current, '@0@.@1@'.format(current, interface_age)]
+
 libgssdp = library('gssdp-1.2', sources + enums,
-    version : '0.0.0',
+    version : version,
+    darwin_versions : darwin_versions,
     dependencies : dependencies + system_deps,
     include_directories : include_directories('..'),
     install : true)
diff --git a/meson.build b/meson.build
index 7e898eb..3d75cc9 100644
--- a/meson.build
+++ b/meson.build
@@ -1,4 +1,4 @@
-project('gssdp', 'c', version: '1.2.0')
+project('gssdp', 'c', version: '1.2.0', meson_version : '>= 0.48.0')
 gnome = import('gnome')
 pkg = import('pkgconfig')
