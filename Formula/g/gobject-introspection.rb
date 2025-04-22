class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.84/gobject-introspection-1.84.0.tar.xz"
  sha256 "945b57da7ec262e5c266b89e091d14be800cc424277d82a02872b7d794a84779"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]

  bottle do
    sha256 arm64_sequoia: "1940c1701f91ae5e7ef183e793b97be639d16e0f280d3732cecefb77bfd548f9"
    sha256 arm64_sonoma:  "c770a7353969b329ec522b6bae607e2c0568c846ec88788c2da9c60b3aa381b7"
    sha256 arm64_ventura: "349e78cab0c1766fe7ae4af91bf410108a8b3ded48b985be0daab0cd3d92a0df"
    sha256 sonoma:        "625c2a1131e3ed0a03aee948584760f5958d7fed46ef9a54cadeb29478b0b6da"
    sha256 ventura:       "e6058df37dbcc91b27a6dcd1dc776bb3b4638419d8619f0e3ca102b650dd98c4"
    sha256 arm64_linux:   "cc2a4f86e227bac0d4f3eeb3d7c0c9cf19ffbd26f4bc9d8c78b73504c5750670"
    sha256 x86_64_linux:  "425a0209cd907de97d5d0251d76a297d5837bac7ae79625daab9eafd036e6554"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkgconf"
  # Ships a `_giscanner.cpython-312-darwin.so`, so needs a specific version.
  depends_on "python@3.13"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  resource "mako" do
    url "https://files.pythonhosted.org/packages/62/4f/ddb1965901bc388958db9f0c991255b2c469349a741ae8c9cd8a562d70a6/mako-1.3.9.tar.gz"
    sha256 "b5d65ff3462870feec922dbccf38f6efb44e5714d7b593a656be86663d8600ac"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/54/28/3af612670f82f4c056911fbbbb42760255801b3068c48de792d354ff4472/markdown-3.7.tar.gz"
    sha256 "2ae2471477cfd02dbbf038d5d9bc226d40def84b4fe2986e49b59b6b472bbed2"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/d2/7b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732/setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch :DATA

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"
    if OS.mac? && MacOS.version == :ventura && DevelopmentTools.clang_build_version == 1500
      ENV.append "LDFLAGS", "-Wl,-ld_classic"
    end

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{venv.root}/bin/python",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"main.c").write <<~C
      #include <girepository.h>

      int main (int argc, char *argv[]) {
        GIRepository *repo = g_irepository_get_default();
        g_assert_nonnull(repo);
        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs gobject-introspection-1.0").strip.split
    system ENV.cc, "main.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end

__END__
diff --git a/girepository/gitypelib.c b/girepository/gitypelib.c
index 29349da..5619cfb 100644
--- a/girepository/gitypelib.c
+++ b/girepository/gitypelib.c
@@ -2261,6 +2261,22 @@ load_one_shared_library (const char *shlib)
 {
   GSList *p;
   GModule *m;
+#ifdef EXTRA_LIBRARY_PATHS
+  static gsize extra_libs_initialized = 0;
+
+  if (g_once_init_enter (&extra_libs_initialized))
+    {
+      gchar **paths = g_strsplit(EXTRA_LIBRARY_PATHS, G_SEARCHPATH_SEPARATOR_S, 0);
+      gint i;
+      gsize initialized = 1;
+      for (i = g_strv_length(paths) - 1 ; i >= 0 ; i--)
+        {
+          g_irepository_prepend_library_path(paths[i]);
+	      }
+      g_strfreev(paths);
+      g_once_init_leave (&extra_libs_initialized, initialized);
+    }
+#endif
 
 #ifdef __APPLE__
   /* On macOS, @-prefixed shlib paths (@rpath, @executable_path, @loader_path)
diff --git a/meson.build b/meson.build
index 7b8bf1c..ea29ff5 100644
--- a/meson.build
+++ b/meson.build
@@ -222,6 +222,10 @@ if host_system in ['windows', 'cygwin']
   g_ir_scanner_env.prepend(var, gio_dep.get_variable('giomoduledir'))
 endif
 
+if get_option('extra_library_paths') != ''
+  config.set_quoted('EXTRA_LIBRARY_PATHS', get_option('extra_library_paths'))
+endif
+
 configure_file(
   configuration: config,
   output: 'config.h'
diff --git a/meson_options.txt b/meson_options.txt
index cbc63ed..e2e7577 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -49,3 +49,7 @@ option('gi_cross_pkgconfig_sysroot_path', type: 'string',
 option('tests', type: 'boolean', value: true,
   description: 'Build and run tests'
 )
+
+option('extra_library_paths', type: 'string',
+  description: 'A list of file paths, joined together using the searchpath separator character, that will be used to search for shared libraries'
+)
