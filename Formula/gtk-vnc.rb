class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.0/gtk-vnc-1.0.0.tar.xz"
  sha256 "a81a1f1a79ad4618027628ffac27d3391524c063d9411c7a36a5ec3380e6c080"

  bottle do
    sha256 "f6e79e525133ea8c72d4be4b0719299141a8b206b9f547fd27b882b06a817f01" => :catalina
    sha256 "1e932ef0f54e09e9cf107c6ef386ff49e1b1cfd107eca77e4d1c5569da71909d" => :mojave
    sha256 "efb82f38076361165896bbf906881331c349082464fa8fc0b6b81f4c58b52f0a" => :high_sierra
    sha256 "c244ffda67d3e559172ba2b9e2b1015011733630232c203f733f259d8a6dd485" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  # submitted upstream at https://gitlab.gnome.org/GNOME/gtk-vnc/merge_requests/4
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dwith-vala=false", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gvnccapture", "--help"
  end
end

__END__
diff --git a/src/meson.build b/src/meson.build
index 956f189..e238bc3 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -89,7 +89,7 @@ else
 endif

 gvnc_link_args = []
-if host_machine.system() != 'windows'
+if meson.get_compiler('c').has_link_argument('-Wl,--no-undefined')
   gvnc_link_args += ['-Wl,--no-undefined']
 endif

@@ -116,6 +116,15 @@ gvnc_inc = [
   top_incdir,
 ]

+c_args = []
+
+if host_machine.system() == 'darwin'
+  # fix "The deprecated ucontext routines require _XOPEN_SOURCE to be defined"
+  c_args += ['-D_XOPEN_SOURCE=600']
+  # for MAP_ANON
+  c_args += ['-D_DARWIN_C_SOURCE']
+endif
+
 gvnc = library(
   'gvnc-1.0',
   sources: gvnc_sources,
@@ -123,8 +132,10 @@ gvnc = library(
   include_directories: gvnc_inc,
   link_args: gvnc_link_args,
   version: '0.0.1',
+  darwin_versions: ['1.0', '1.1'],
   soversion: '0',
   install: true,
+  c_args: c_args,
 )

 gvnc_dep = declare_dependency(
@@ -178,7 +189,7 @@ if libpulse_dep.found()
   ]

   gvncpulse_link_args = []
-  if host_machine.system() != 'windows'
+  if meson.get_compiler('c').has_link_argument('-Wl,--no-undefined')
     gvncpulse_link_args += ['-Wl,--no-undefined']
   endif

@@ -206,6 +217,7 @@ if libpulse_dep.found()
     include_directories: gvncpulse_inc,
     link_args: gvncpulse_link_args,
     version: '0.0.1',
+    darwin_versions: ['1.0', '1.1'],
     soversion: '0',
     install: true,
   )
@@ -337,7 +349,7 @@ endforeach


 gtk_vnc_link_args = []
-if host_machine.system() != 'windows'
+if meson.get_compiler('c').has_link_argument('-Wl,--no-undefined')
   gtk_vnc_link_args += ['-Wl,--no-undefined']
 endif

@@ -369,6 +381,7 @@ gtk_vnc = library(
   include_directories: gtk_vnc_inc,
   link_args: gtk_vnc_link_args,
   version: '0.0.2',
+  darwin_versions: ['1.0', '1.2'],
   soversion: '0',
   install: true,
 )
