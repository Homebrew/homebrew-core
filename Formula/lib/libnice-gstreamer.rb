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
    sha256 cellar: :any, arm64_golden_gate: "eafc930427dddbb9a543d13e039c53779bc93f93cdff7a4fc7f41d518cb190a5"
    sha256 cellar: :any, arm64_tahoe:       "4534e775b787529c00fc1f4954c4cb2cd0162e90bd0c687302580d65f5d3ece5"
    sha256 cellar: :any, arm64_sequoia:     "3244ebe9c99c296fff087230259455ca9ec34a70ccf51edf2f9300eaa5290012"
    sha256 cellar: :any, arm64_sonoma:      "670e31e436f75b1c09fd9683adb166309cf786a868d6e5f702e85052c015fc44"
    sha256 cellar: :any, arm64_linux:       "56099682e9761c9d01a47e32a4da76fd3cfd1a88a695e8fb6cbe6f25bb4ba7f2"
    sha256 cellar: :any, x86_64_linux:      "7b5a4536f58eb1f357d29702c92fe935ebd4428ec0f4d41ec66f05bb8e50713f"
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
    (testpath/"test.c").write <<~C
      #include <gst/gst.h>

      int main(int argc, char **argv) {
        gst_init(&argc, &argv);
        GstElementFactory *factory = gst_element_factory_find("nicesrc");
        g_assert_nonnull(factory);
        gst_object_unref(factory);
        gst_deinit();
        return 0;
      }
    C
    # Use the library API as `gst-inspect-1.0` starts NSApplication, which hangs without a window server
    ENV["GST_PLUGIN_SYSTEM_PATH"] = opt_libexec/"gstreamer-1.0"
    flags = shell_output("pkg-config --cflags --libs gstreamer-1.0").chomp.split
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
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
