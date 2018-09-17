class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.28/gnome-builder-3.28.4.tar.xz"
  sha256 "05281f01e66fde8fcd89af53709053583cf74d0ae4ac20b37185664f25396b45"

  bottle do
    sha256 "1bde6ecb92fb4a42b3de47323b4efe1a5234aee985f40721e0bc9b59b8a7e839" => :mojave
    sha256 "b2068860adae8eee244a324fba083aa3bfdefef7962c894c320741802f199ad3" => :high_sierra
    sha256 "f0f008cab0a9c58973980c8386b9bf76e1305aa8d934d98b5916b861251fc87d" => :sierra
    sha256 "4845a2b8a31cd6eeca400f5216aa806a3521f4640ddf6957de89646cc86abe06" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "adwaita-icon-theme"
  depends_on "dbus"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libdazzle"
  depends_on "libgit2-glib"
  depends_on "libpeas"
  depends_on "libxml2"
  depends_on "template-glib"
  depends_on "vte3"

  # fix sandbox violation and remove unavailable linker option
  patch :DATA

  needs :cxx11

  def install
    ENV.cxx11
    ENV["DESTDIR"] = ""

    args = %W[
      --prefix=#{prefix}
      -Dwith_git=true
      -Dwith_autotools=true
      -Dwith_history=true
      -Dwith_webkit=false
      -Dwith_clang=false
      -Dwith_devhelp=false
      -Dwith_flatpak=false
      -Dwith_sysprof=false
      -Dwith_vapi=false
      -Dwith_vala_pack=false
      -Dwith_qemu=false
      -Dwith_safe_path=#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin
    ]

    # prevent sandbox violation
    pyver = Language::Python.major_minor_version "python3"
    inreplace "src/libide/meson.build",
              "install_dir: pygobject_override_dir",
              "install_dir: '#{lib}/python#{pyver}/site-packages'"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja"
      system "ninja", "install"
    end

    # meson-internal gives wrong install_names for dylibs due to their unusual installation location
    # create softlinks to fix
    ln_s Dir.glob("#{lib}/gnome-builder/*dylib"), lib
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnome-builder --version")
  end
end

__END__
diff --git a/src/libide/meson.build b/src/libide/meson.build
index 055801b..4e29f9d 100644
--- a/src/libide/meson.build
+++ b/src/libide/meson.build
@@ -160,37 +160,6 @@ if get_option('with_editorconfig')
   ]
 endif

-# We want to find the subdirectory to install our override into:
-python3 = find_program('python3')
-
-get_overridedir = '''
-import os
-import sysconfig
-
-libdir = sysconfig.get_config_var('LIBDIR')
-if not libdir:
-  libdir = '/usr/lib'
-
-try:
-  import gi
-  overridedir = gi._overridesdir
-except ImportError:
-  purelibdir = sysconfig.get_path('purelib')
-  overridedir = os.path.join(purelibdir, 'gi', 'overrides')
-
-if overridedir.startswith(libdir): # Should always be True..
-  overridedir = overridedir[len(libdir) + 1:]
-
-print(overridedir)
-'''
-
-ret = run_command([python3, '-c', get_overridedir])
-if ret.returncode() != 0
-  error('Failed to determine pygobject overridedir')
-else
-  pygobject_override_dir = join_paths(get_option('libdir'), ret.stdout().strip())
-endif
-
 install_data('Ide.py', install_dir: pygobject_override_dir)

 libide_deps = [
diff --git a/src/plugins/meson.build b/src/plugins/meson.build
index d97d7e3..646e7f3 100644
--- a/src/plugins/meson.build
+++ b/src/plugins/meson.build
@@ -5,10 +5,8 @@ gnome_builder_plugins_sources = ['gnome-builder-plugins.c']
 gnome_builder_plugins_args = []
 gnome_builder_plugins_deps = [libpeas_dep, libide_plugin_dep, libide_dep]
 gnome_builder_plugins_link_with = []
-gnome_builder_plugins_link_deps = join_paths(meson.current_source_dir(), 'plugins.map')
-gnome_builder_plugins_link_args = [
-  '-Wl,--version-script,' + gnome_builder_plugins_link_deps,
-]
+gnome_builder_plugins_link_deps = []
+gnome_builder_plugins_link_args = []

 subdir('autotools')
 subdir('autotools-templates')
@@ -76,7 +74,6 @@ gnome_builder_plugins = shared_library(
   gnome_builder_plugins_sources,

    dependencies: gnome_builder_plugins_deps,
-   link_depends: 'plugins.map',
          c_args: gnome_builder_plugins_args,
       link_args: gnome_builder_plugins_link_args,
       link_with: gnome_builder_plugins_link_with,

diff --git a/src/main.c b/src/main.c
index f3bea6d..8f7eab8 100644
--- a/src/main.c
+++ b/src/main.c
@@ -109,6 +109,9 @@ main (int   argc,
   /* Setup our gdb fork()/exec() helper */
   bug_buddy_init ();

+  /* macOS dbus hack */
+  g_setenv("DBUS_SESSION_BUS_ADDRESS", "launchd:env=DBUS_LAUNCHD_SESSION_BUS_SOCKET", TRUE);
+
   /*
    * We require a desktop session that provides a properly working
    * DBus environment. Bail if for some reason that is not the case.
