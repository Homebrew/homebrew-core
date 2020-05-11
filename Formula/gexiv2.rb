class Gexiv2 < Formula
  desc "GObject wrapper around the Exiv2 photo metadata library"
  homepage "https://wiki.gnome.org/Projects/gexiv2"
  url "https://download.gnome.org/sources/gexiv2/0.12/gexiv2-0.12.0.tar.xz"
  sha256 "58f539b0386f36300b76f3afea3a508de4914b27e78f58ee4d142486a42f926a"
  revision 2

  bottle do
    cellar :any
    sha256 "b8a21bf1ca1b330e8dc95c69d4eb520b170e77c2765743676baf75b46b2d314e" => :catalina
    sha256 "eb63013a8b8c8a60f0be08862a447bcf0f77dc7fd766087391f2dcec36057701" => :mojave
    sha256 "59b9ac3558ecab3f9f9e577c2f9bb8c004f2dd828dd02ac581295bfa78192e26" => :high_sierra
    sha256 "fc5ca44652f5f4fe511036dc73dd9c495aeaa8261b5d9a898077ca5cfabac50b" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "vala" => :build
  depends_on "exiv2"
  depends_on "glib"

  # submitted upstream as https://gitlab.gnome.org/GNOME/gexiv2/merge_requests/10
  patch :DATA

  def install
    pyver = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dpython3_girdir=#{lib}/python#{pyver}/site-packages/gi/overrides", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gexiv2/gexiv2.h>
      int main() {
        GExiv2Metadata *metadata = gexiv2_metadata_new();
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-L#{lib}",
      "-lgexiv2",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gexiv2/meson.build b/gexiv2/meson.build
index 196b298..12abf92 100644
--- a/gexiv2/meson.build
+++ b/gexiv2/meson.build
@@ -2,6 +2,13 @@ pkg = import('pkgconfig')

 as_version = meson.project_version().split('.')

+libversion = '2.0.0'
+libversion_arr = libversion.split('.')
+darwin_version_major = libversion_arr[0].to_int()
+darwin_version_minor = libversion_arr[1].to_int()
+darwin_version_micro = libversion_arr[2].to_int()
+darwin_versions = [darwin_version_major + darwin_version_minor + 1, '@0@.@1@'.format(darwin_version_major + darwin_version_minor + 1, darwin_version_micro)]
+
 gexiv2_include_dir = join_paths(get_option('includedir'), 'gexiv2')

 config = configuration_data()
@@ -53,7 +60,8 @@ gexiv2 = library('gexiv2',
                  [version_header] +
                  enum_sources,
                  include_directories : include_directories('..'),
-                 version: '2.0.0',
+                 version: libversion,
+                 darwin_versions: darwin_versions,
                  dependencies : [gobject, exiv2, gio],
                  install : true)

diff --git a/meson.build b/meson.build
index 601afc1..b84255f 100644
--- a/meson.build
+++ b/meson.build
@@ -2,6 +2,7 @@ project(
     'gexiv2',
     ['c', 'cpp'],
     version : '0.12.0',
+    meson_version : '>=0.48',
     default_options : [
         'cpp_std=c++11'
     ]
