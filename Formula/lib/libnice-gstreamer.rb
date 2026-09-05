class LibniceGstreamer < Formula
  desc "GStreamer Plugin for libnice"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.24.tar.gz"
  sha256 "cfb5e8e778534f2f5b3c6f4958a1eb057c6b95c537c0f100817a537cf5d64fcc"
  license any_of: ["LGPL-2.1-or-later", "MPL-1.1"]

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
gstreamer and libnice. Refreshed for 0.1.24, which added `gst_net_dep`
to the `gstnice` library dependencies.

diff --git a/gst/gstnicesink.h b/gst/gstnicesink.h
--- a/gst/gstnicesink.h
+++ b/gst/gstnicesink.h
@@ -41,7 +41,7 @@
 #include <gst/gst.h>
 #include <gst/base/gstbasesink.h>
 
-#include <nice/nice.h>
+#include <nice.h>
 
 G_BEGIN_DECLS
 
diff --git a/gst/gstnicesrc.h b/gst/gstnicesrc.h
--- a/gst/gstnicesrc.h
+++ b/gst/gstnicesrc.h
@@ -41,7 +41,7 @@
 #include <gst/gst.h>
 #include <gst/base/gstpushsrc.h>
 
-#include <nice/nice.h>
+#include <nice.h>
 
 G_BEGIN_DECLS
 
diff --git a/gst/meson.build b/gst/meson.build
--- a/gst/meson.build
+++ b/gst/meson.build
@@ -8,10 +8,11 @@
 
 gst_plugins_install_dir = join_paths(get_option('libdir'), 'gstreamer-1.0')
 
+configure_file(output : 'config.h', configuration : cdata)
+
 libgstnice = library('gstnice',
   gst_nice_sources,
   c_args : gst_nice_args,
-  include_directories: nice_incs,
   dependencies: [libnice_dep, gst_dep, gst_net_dep],
   install_dir: gst_plugins_install_dir,
   install: true)
diff --git a/meson.build b/meson.build
--- a/meson.build
+++ b/meson.build
@@ -31,6 +31,7 @@
 
 cc = meson.get_compiler('c')
 static_build = get_option('default_library') == 'static'
+gstreamer_plugin_only = get_option('gstreamer-plugin-only')
 
 syslibs = []
 
@@ -81,6 +82,15 @@
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
@@ -317,11 +327,15 @@
 
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
@@ -337,11 +351,11 @@
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
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -2,6 +2,8 @@
   description: 'Enable or disable GUPnP IGD support')
 option('gstreamer', type: 'feature', value: 'auto',
   description: 'Enable or disable build of GStreamer plugins')
+option('gstreamer-plugin-only', type: 'boolean', value: 'false',
+  description: 'Only build the gstreamer plugin, for breaking the circular dependency')
 option('ignored-network-interface-prefix', type: 'array', value: ['docker', 'veth', 'virbr', 'vnet'],
   description: 'Ignore network interfaces whose name starts with a string from this list in the ICE connection check algorithm. For example, "virbr" to ignore virtual bridge interfaces added by virtd, which do not help in finding connectivity.')
 option('crypto-library', type: 'combo', choices : ['auto', 'gnutls', 'openssl'], value : 'auto')
