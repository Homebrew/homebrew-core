class GobjectIntrospection < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Generate introspection data for GObject libraries"
  homepage "https://gi.readthedocs.io/en/latest/"
  url "https://download.gnome.org/sources/gobject-introspection/1.86/gobject-introspection-1.86.0.tar.xz"
  sha256 "920d1a3fcedeadc32acff95c2e203b319039dd4b4a08dd1a2dfd283d19c0b9ae"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later", "MIT"]
  revision 6
  compatibility_version 1

  bottle do
    sha256 arm64_golden_gate: "63be135be0568cc8afe5e9ccf1a2a6e4ea80e2697be161f3969bf90be2644327"
    sha256 arm64_tahoe:       "110ea2facc0e93d90a1d28b21e532bd7d0a716b24c41be62f8f2e3543505dddc"
    sha256 arm64_sequoia:     "75f33d27b15bd5b9f92c66068a6c8dbe7cb9fc9b9fd62006708b2d86cd2536cc"
    sha256 arm64_linux:       "e450f8b697ac85b6cd375789277684496457eb8933749ccb6e56d4395db772e1"
    sha256 x86_64_linux:      "a1a9fa721e8ffabd07325e8d824fbad72bec7e282623323c8d3f8fefe734e760"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "pkgconf"
  # Ships a `_giscanner.cpython-315-darwin.so`, so needs a specific version.
  depends_on "python@3.15"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  pypi_packages package_name:   "",
                extra_packages: %w[mako markdown setuptools]

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/f4/32/0b4d0297064244f04af4331b65de16237cc3cce07474171ee14222a28981/markdown-3.11.2.tar.gz"
    sha256 "87bf5d90f2d2882e2c02fcda182c2800456b985bff38913867c49706481514b0"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  # Fix library search path on non-/usr/local installs (e.g. Apple Silicon)
  # See: https://github.com/Homebrew/homebrew-core/issues/75020
  #      https://gitlab.gnome.org/GNOME/gobject-introspection/-/merge_requests/273
  patch :DATA

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    ENV["GI_SCANNER_DISABLE_CACHE"] = "true"

    inreplace "giscanner/transformer.py", "/usr/share", "#{HOMEBREW_PREFIX}/share"
    inreplace "meson.build",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', join_paths(get_option('prefix'), get_option('libdir')))",
      "config.set_quoted('GOBJECT_INTROSPECTION_LIBDIR', '#{HOMEBREW_PREFIX}/lib')"

    system "meson", "setup", "build", "-Dpython=#{venv.root}/bin/python",
                                      "-Dextra_library_paths=#{HOMEBREW_PREFIX}/lib",
                                      "-Dtests=false",
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
