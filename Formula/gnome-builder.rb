class GnomeBuilder < Formula
  desc "IDE for GNOME"
  homepage "https://wiki.gnome.org/Apps/Builder"
  url "https://download.gnome.org/sources/gnome-builder/3.30/gnome-builder-3.30.3.tar.xz"
  sha256 "9998f3d41d9526fdbf274cae712fafe7b79d0b9d1dd5739c6c2141e5e5550686"
  revision 2

  bottle do
    sha256 "b4a7f7f5bd1d17500b3a9981d6068dab4c680f483248fb8ea78285dcedefb694" => :mojave
    sha256 "95d992e11e9588abb1821a799a071be4b67f93cd33f38865ed61543b625a8734" => :high_sierra
    sha256 "3fc5614f3ac55940a141ad621931566b2ff049990c5decc7f36504c723e0cf29" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "adwaita-icon-theme"
  depends_on "dbus"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "gtksourceview4"
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

  def install
    ENV.cxx11
    ENV["DESTDIR"] = "/"

    # prevent sandbox violation
    pyver = Language::Python.major_minor_version "python3"

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
      -Dwith_project_tree=false
      -Dpython_libprefix=python#{pyver}
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja"
      system "ninja", "install"
    end
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
diff --git a/src/main.c b/src/main.c
index 9897203..212859a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -77,6 +77,9 @@ main (int   argc,
   /* Always ignore SIGPIPE */
   signal (SIGPIPE, SIG_IGN);

+  /* macOS dbus hack */
+  g_setenv("DBUS_SESSION_BUS_ADDRESS", "launchd:env=DBUS_LAUNCHD_SESSION_BUS_SOCKET", TRUE);
+
   /*
    * We require a desktop session that provides a properly working
    * DBus environment. Bail if for some reason that is not the case.
diff --git a/src/plugins/meson.build b/src/plugins/meson.build
index bd99831..8ba8819 100644
--- a/src/plugins/meson.build
+++ b/src/plugins/meson.build
@@ -7,7 +7,6 @@ gnome_builder_plugins_deps = [libpeas_dep, libide_plugin_dep, libide_dep]
 gnome_builder_plugins_link_with = []
 gnome_builder_plugins_link_deps = join_paths(meson.current_source_dir(), 'plugins.map')
 gnome_builder_plugins_link_args = [
-  '-Wl,--version-script,' + gnome_builder_plugins_link_deps,
 ]

 subdir('autotools')
@@ -80,7 +79,6 @@ gnome_builder_plugins = shared_library(
   gnome_builder_plugins_sources,

    dependencies: gnome_builder_plugins_deps,
-   link_depends: 'plugins.map',
          c_args: gnome_builder_plugins_args + release_args,
       link_args: gnome_builder_plugins_link_args,
       link_with: gnome_builder_plugins_link_with,

