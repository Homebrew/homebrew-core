class GobjectIntrospection < Formula
  desc "Generate introspection data for GObject libraries"
  homepage "https://wiki.gnome.org/Projects/GObjectIntrospection"
  url "https://download.gnome.org/sources/gobject-introspection/1.62/gobject-introspection-1.62.0.tar.xz"
  sha256 "b1ee7ed257fdbc008702bdff0ff3e78a660e7e602efa8f211dc89b9d1e7d90a2"

  bottle do
    sha256 "aebf18135464982195e0f14d8a5fd76dd03ef91fa45e3648500576228aec97fc" => :mojave
    sha256 "ab5bff1ce824a2621d7f90296e84499f80275e9370955231ea9de5ff574c2ecf" => :high_sierra
    sha256 "dcd2ffc04732cd3e60e8f1de914838492d1f37d07d8bb26201fd0c25b634cbc3" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "libffi"
  depends_on "pkg-config"
  depends_on "python"

  resource "tutorial" do
    url "https://gist.github.com/7a0023656ccfe309337a.git",
        :revision => "499ac89f8a9ad17d250e907f74912159ea216416"
  end

  # submitted upstream as https://gitlab.gnome.org/GNOME/gobject-introspection/merge_requests/177
  patch :DATA

  def install
    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    args = %W[
      --prefix=#{prefix}
      -Dpython=#{Formula["python"].opt_bin}/python3
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libffi"].opt_lib/"pkgconfig"
    resource("tutorial").stage testpath
    system "make"
    assert_predicate testpath/"Tut-0.1.typelib", :exist?
  end
end

__END__
diff --git a/girepository/meson.build b/girepository/meson.build
index 0183153e..204659fe 100644
--- a/girepository/meson.build
+++ b/girepository/meson.build
@@ -163,6 +163,15 @@ if cc.get_id() != 'msvc'
   ])
 endif

+lib_version = '1.0.0'
+lib_version_arr = lib_version.split('.')
+lib_version_major = lib_version_arr[0].to_int()
+lib_version_minor = lib_version_arr[1].to_int()
+lib_version_micro = lib_version_arr[2].to_int()
+
+osx_current = lib_version_major + 1
+lib_osx_version = [osx_current, '@0@.@1@'.format(osx_current, lib_version_minor)]
+
 girepo_lib = shared_library('girepository-1.0',
   sources: girepo_sources,
   include_directories : configinc,
@@ -170,7 +179,8 @@ girepo_lib = shared_library('girepository-1.0',
           custom_c_args,
   dependencies: [glib_dep, gobject_dep, gmodule_dep,
                  gio_dep, girepo_internals_dep],
-  version: '1.0.0',
+  version: lib_version,
+  darwin_versions: lib_osx_version,
   install: true,
 )
