class LibniceGstreamer < Formula
  desc "GStreamer Plugin for libnice"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.22.tar.gz"
  sha256 "a5f724cf09eae50c41a7517141d89da4a61ec9eaca32da4a0073faed5417ad7e"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    formula "libnice"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "aa2003f8a95578016094c529b41b9e0afae4124421796c7917f2af3dee116c41"
    sha256 cellar: :any, arm64_sonoma:  "e78f31b88426c267bd4ccc9626494130fe1f02cf2279a2941f32b96f825e0742"
    sha256 cellar: :any, arm64_ventura: "b2c462902cec4eb8b59e895c9b2cc9e027b42d1421dcf0f8199c9ee41bace504"
    sha256 cellar: :any, sonoma:        "f1289203e767492cbe9662b55f2a57f475756599cd76bee48496236f544bf52f"
    sha256 cellar: :any, ventura:       "919a1d68e6aee4608a4de25f0ca4db6e9619d8721f83c638b9426531116a92e4"
    sha256               arm64_linux:   "6fce42f6e93b85c2cee857d783c4ce310d41d53686ff54f6b7cdcabc50f1860f"
    sha256               x86_64_linux:  "7afcec37ace358ed8bbd079e36333af68605f2d592828ffdf3dc492c7dc7e963"
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
---
 .gitlab-ci.yml    | 12 ++++++++++++
 gst/gstnicesink.h |  2 +-
 gst/gstnicesrc.h  |  2 +-
 gst/meson.build   |  3 ++-
 meson.build       | 32 +++++++++++++++++++++-----------
 meson_options.txt |  2 ++
 6 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 88102067..00b8dff1 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -89,6 +89,18 @@ build:
     paths:
       - build/

+build gstreamer-plugin-only:
+  stage: build
+  extends:
+  - build
+  script:
+    ## && true to make gitlab-ci happy
+    - source scl_source enable rh-python36 && true
+    - meson --werror --warnlevel 2 -Dgtk_doc=enabled -Dgstreamer=disabled -Dgstreamer-plugin-only=false --prefix=$PREFIX -Db_coverage=true build_libs/
+    - ninja -C build_libs install
+    - meson --werror --warnlevel 2 -Dgstreamer=enabled -Dgstreamer-plugin-only=true --prefix=$PREFIX -Db_coverage=true --pkg-config-path=$PREFIX/lib64/pkgconfig build_plugin/
+    - ninja -C build_plugin/ install
+

 .build windows:
   image: 'registry.freedesktop.org/gstreamer/gstreamer/amd64/windows:2023-08-24.0-main'
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
index 4faffb40..81cd7eaf 100644
--- a/meson.build
+++ b/meson.build
@@ -31,6 +31,7 @@ nice_datadir = join_paths(get_option('prefix'), get_option('datadir'))

 cc = meson.get_compiler('c')
 static_build = get_option('default_library') == 'static'
+gstreamer_plugin_only = get_option('gstreamer-plugin-only')

 syslibs = []

@@ -79,12 +80,17 @@ add_project_arguments('-D_GNU_SOURCE',
   '-DHAVE_CONFIG_H',
   '-DGLIB_VERSION_MIN_REQUIRED=GLIB_VERSION_' + glib_req_minmax_str,
   '-DGLIB_VERSION_MAX_ALLOWED=GLIB_VERSION_' + glib_req_minmax_str,
-  '-DNICE_VERSION_MAJOR=' + version_major,
-  '-DNICE_VERSION_MINOR=' + version_minor,
-  '-DNICE_VERSION_MICRO=' + version_micro,
-  '-DNICE_VERSION_NANO=' + version_nano,
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
 cdata = configuration_data()

 cdata.set_quoted('PACKAGE_STRING', meson.project_name())
@@ -296,11 +302,15 @@ endif

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
@@ -316,11 +326,11 @@ else
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
