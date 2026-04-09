class LibniceGstreamer < Formula
  desc "GStreamer Plugin for libnice"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.23.tar.gz"
  sha256 "618fc4e8de393b719b1641c1d8eec01826d4d39d15ade92679d221c7f5e4e70d"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    formula "libnice"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c35c126361bae664d0cedd53e2df6115a1303cf2566b9a28a3486b2159731f5"
    sha256 cellar: :any, arm64_sequoia: "0e77dffa693e48f2ba455657fa744c595799b86655b695524c41bd3b983a6c5d"
    sha256 cellar: :any, arm64_sonoma:  "f6ab16d942ef72dccb8278e2b8da25381edd0a6e394020b87d50e1f6a6d7a0b9"
    sha256 cellar: :any, sonoma:        "f78f64870d3d5ec10b8cf25af5ac7ae92c3106b577f1bf13d9cab0dccbe9fbb7"
    sha256               arm64_linux:   "ed30b7a595d0bf0f5798158f4f142af5c71ae72d0e3fe9a4c815beca104df736"
    sha256               x86_64_linux:  "2570d646e3fff87a4227109021740629384f63d27278ae1ec5060278c6169148"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "libnice"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "intltool" => :build
  end

  # Enable building only the gstreamer plugin
  # https://gitlab.freedesktop.org/libnice/libnice/-/merge_requests/271
  patch :DATA

  def install
    system "meson", "setup", "build", "-Dgstreamer=enabled", "-Dgstreamer-plugin-only=true", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Move the gstreamer plugin out of the way to prevent `brew link` conflicts.
    libexec.install lib/"gstreamer-1.0"
  end

  test do
    system "gst-inspect-1.0", "--exists", "nicesrc"
  end
end

__END__
From aa632be3d9f2e7ec309a1312ddb7ff4cc538ea2e Mon Sep 17 00:00:00 2001
From: Nirbheek Chauhan <nirbheek@centricular.com>
Date: Wed, 21 Feb 2024 18:15:51 +0530
Subject: [PATCH] meson: Add an option to build only the gstreamer plugin

This is one possible approach to break the circular dep between
gstreamer and libnice.

diff --git a/gst/gstnicesink.h b/gst/gstnicesink.h
index b9e6e6c5..49c2d5ce 100644
--- a/gst/gstnicesink.h
+++ b/gst/gstnicesink.h
@@ -41,7 +41,7 @@
 #include <gst/gst.h>
 #include <gst/base/gstbasesink.h>

-#include <nice/nice.h>
+#include <nice.h>

 G_BEGIN_DECLS

diff --git a/gst/gstnicesrc.h b/gst/gstnicesrc.h
index 9d00bfaa..8b906e6f 100644
--- a/gst/gstnicesrc.h
+++ b/gst/gstnicesrc.h
@@ -41,7 +41,7 @@
 #include <gst/gst.h>
 #include <gst/base/gstpushsrc.h>

-#include <nice/nice.h>
+#include <nice.h>

 G_BEGIN_DECLS

diff --git a/gst/meson.build b/gst/meson.build
index 4ed4794f..31e3e5fb 100644
--- a/gst/meson.build
+++ b/gst/meson.build
@@ -8,10 +8,11 @@ gst_nice_args = ['-DGST_USE_UNSTABLE_API']

 gst_plugins_install_dir = join_paths(get_option('libdir'), 'gstreamer-1.0')

+configure_file(output : 'config.h', configuration : cdata)
+
 libgstnice = library('gstnice',
   gst_nice_sources,
   c_args : gst_nice_args,
-  include_directories: nice_incs,
   dependencies: [libnice_dep, gst_dep],
   install_dir: gst_plugins_install_dir,
   install: true)
diff --git a/meson.build b/meson.build
index 3936658..12f6601 100644
--- a/meson.build
+++ b/meson.build
@@ -31,6 +31,7 @@ nice_datadir = join_paths(get_option('prefix'), get_option('datadir'))
 
 cc = meson.get_compiler('c')
 static_build = get_option('default_library') == 'static'
+gstreamer_plugin_only = get_option('gstreamer-plugin-only')
 
 syslibs = []
 
@@ -81,6 +82,15 @@ add_project_arguments('-D_GNU_SOURCE',
   '-DGLIB_VERSION_MAX_ALLOWED=GLIB_VERSION_' + glib_req_minmax_str,
   language: 'c')
 
+if not gstreamer_plugin_only
+  add_project_arguments(
+    '-DNICE_VERSION_MAJOR=' + version_major,
+    '-DNICE_VERSION_MINOR=' + version_minor,
+    '-DNICE_VERSION_MICRO=' + version_micro,
+    '-DNICE_VERSION_NANO=' + version_nano,
+    language: 'c')
+endif
+
 # Same logic as in GLib.
 glib_debug = get_option('glib_debug')
 disable_cast_checks = glib_debug.disabled() or (
@@ -313,11 +323,15 @@ endif
 
 gir = find_program('g-ir-scanner', required : get_option('introspection'))
 
-subdir('agent')
-subdir('stun')
-subdir('socket')
-subdir('random')
-subdir('nice')
+if gstreamer_plugin_only
+  libnice_dep = dependency('nice', version: '=' + meson.project_version())
+else
+  subdir('agent')
+  subdir('stun')
+  subdir('socket')
+  subdir('random')
+  subdir('nice')
+endif
 
 if gst_dep.found()
   subdir('gst')
@@ -333,11 +347,11 @@ else
   endif
 endif
 
-if not get_option('tests').disabled()
+if not gstreamer_plugin_only and not get_option('tests').disabled()
   subdir('tests')
 endif
 
-if not get_option('examples').disabled()
+if not gstreamer_plugin_only and not get_option('examples').disabled()
   subdir('examples')
 endif
 
diff --git a/meson_options.txt b/meson_options.txt
index cd980cb5..cd7c879b 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -2,6 +2,8 @@ option('gupnp', type: 'feature', value: 'auto',
   description: 'Enable or disable GUPnP IGD support')
 option('gstreamer', type: 'feature', value: 'auto',
   description: 'Enable or disable build of GStreamer plugins')
+option('gstreamer-plugin-only', type: 'boolean', value: 'false',
+  description: 'Only build the gstreamer plugin, for breaking the circular dependency')
 option('ignored-network-interface-prefix', type: 'array', value: ['docker', 'veth', 'virbr', 'vnet'],
   description: 'Ignore network interfaces whose name starts with a string from this list in the ICE connection check algorithm. For example, "virbr" to ignore virtual bridge interfaces added by virtd, which do not help in finding connectivity.')
 option('crypto-library', type: 'combo', choices : ['auto', 'gnutls', 'openssl'], value : 'auto')
--
GitLab
