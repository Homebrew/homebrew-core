class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.8.3.tar.xz"
    sha256 "7899fcb18e6a1af2888b19c90213af018a57d741c6e72ec56b133bc73ec8509b"

    # https://bugzilla.gnome.org/show_bug.cgi?id=770587
    # Upstream commit 807b0322c50dfe17c55a8304c0278c2d59fa8358 with conflicts fixed.
    patch :DATA
  end

  bottle do
    sha256 "ac06d0d507132e957db67ab70e695ca217dadb58fae6eac7898b524f3274fa8f" => :el_capitan
    sha256 "56ee0524b92692aa9f22f56942b9d29ce17e5ef472e41993d4cb21a370f47006" => :yosemite
    sha256 "ea2b3e801bf9ab667af73c6cb2bd03c9f52bf95b8ff991335f6ecfb9baad3609" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"
  end

  depends_on "autoconf" => :build  # Required for "stable" builds because we patch configure.ac
  depends_on "automake" => :build  # Required for "stable" builds because we patch Makefile.am
  depends_on "libtool" => :build

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "openssl"

  depends_on "orc" => :recommended
  depends_on "dirac" => :optional
  depends_on "faac" => :optional
  depends_on "faad2" => :optional
  depends_on "gnutls" => :optional
  depends_on "gtk+3" => :optional
  depends_on "libdvdread" => :optional
  depends_on "libexif" => :optional
  depends_on "libmms" => :optional
  depends_on "homebrew/science/opencv" => :optional
  depends_on "opus" => :optional
  depends_on "rtmpdump" => :optional
  depends_on "schroedinger" => :optional
  depends_on "sound-touch" => :optional
  depends_on "srtp" => :optional
  depends_on "libvo-aacenc" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-sdl
      --disable-debug
      --disable-dependency-tracking
    ]

    # upstream does not support Apple video for older SDKs
    # error: use of undeclared identifier 'AVQueuedSampleBufferRenderingStatusFailed'
    # https://github.com/Homebrew/legacy-homebrew/pull/35284
    if MacOS.version <= :mavericks
      args << "--disable-apple_media"
    end

    args << "--with-gtk=3.0" if build.with? "gtk+3"

    # autogen is invoked in "stable" build because we patch configure.ac
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end

__END__
From 807b0322c50dfe17c55a8304c0278c2d59fa8358 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Sebastian=20Dr=C3=B6ge?= <sebastian@centricular.com>
Date: Tue, 30 Aug 2016 16:21:25 +0300
Subject: applemedia: Conditionally compile qtkitvideosrc

The API was deprecated in 10.9 and apparently does not exist in the SDK for
macOS Sierra anymore.

https://bugzilla.gnome.org/show_bug.cgi?id=770587

diff --git a/configure.ac b/configure.ac
index ce8327b..2787b6c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -543,6 +543,7 @@ dnl *** plug-ins to exclude ***
 AC_CHECK_HEADER(AVFoundation/AVFoundation.h, HAVE_AVFOUNDATION="yes", HAVE_AVFOUNDATION="no", [-])
 AC_CHECK_HEADER(MobileCoreServices/MobileCoreServices.h, HAVE_IOS="yes", HAVE_IOS="no", [-])
 AC_CHECK_HEADER(VideoToolbox/VideoToolbox.h, HAVE_VIDEOTOOLBOX="yes", HAVE_VIDEOTOOLBOX="no", [-])
+AC_CHECK_HEADER(QTKit/QTKit.h, HAVE_QTKIT="yes", HAVE_QTKIT="no", [-])
 
 if test "x$HAVE_VIDEOTOOLBOX" = "xyes"; then
   old_LIBS=$LIBS
@@ -569,6 +570,10 @@ if test "x$HAVE_VIDEOTOOLBOX" = "xyes"; then
   AC_DEFINE(HAVE_VIDEOTOOLBOX, 1, [Define if building with VideoToolbox])
 fi
 
+AM_CONDITIONAL(HAVE_QTKIT, test "x$HAVE_QTKIT" = "xyes")
+if test "x$HAVE_QTKIT" = "xyes"; then
+  AC_DEFINE(HAVE_QTKIT, 1, [Define if building with QTKit])
+fi
 dnl disable gst plugins we might not be able to build on this
 dnl platform: (ugly but minimally invasive)
 dnl FIXME: maybe move to sys, or make work with winsock2
diff --git a/sys/applemedia/Makefile.am b/sys/applemedia/Makefile.am
index 094cce5..d77e47c 100644
--- a/sys/applemedia/Makefile.am
+++ b/sys/applemedia/Makefile.am
@@ -94,16 +94,22 @@ libgstapplemedia_la_LDFLAGS +=			\
 else
 
 libgstapplemedia_la_SOURCES +=			\
-	qtkitvideosrc.m 					\
 	iosurfacememory.c
 
 libgstapplemedia_la_LDFLAGS +=			\
 	-Wl,-framework -Wl,Cocoa		\
-	-Wl,-framework -Wl,QTKit		\
 	-Wl,-framework -Wl,IOSurface
 
 endif
 
+if HAVE_QTKIT
+libgstapplemedia_la_SOURCES +=			\
+	qtkitvideosrc.m
+
+libgstapplemedia_la_LDFLAGS +=			\
+	-Wl,-framework -Wl,QTKit
+endif
+
 if HAVE_AVFOUNDATION
 
 libgstapplemedia_la_SOURCES +=			\
diff --git a/sys/applemedia/plugin.m b/sys/applemedia/plugin.m
index e1e8e9e..19384c7 100644
--- a/sys/applemedia/plugin.m
+++ b/sys/applemedia/plugin.m
@@ -25,7 +25,8 @@
 #include "corevideomemory.h"
 #ifdef HAVE_IOS
 #include "iosassetsrc.h"
-#else
+#endif
+#ifdef HAVE_QTKIT
 #include "qtkitvideosrc.h"
 #endif
 #ifdef HAVE_AVFOUNDATION
@@ -73,7 +74,9 @@ plugin_init (GstPlugin * plugin)
       GST_TYPE_IOS_ASSET_SRC);
 #else
   enable_mt_mode ();
+#endif
 
+#ifdef HAVE_QTKIT
   res = gst_element_register (plugin, "qtkitvideosrc", GST_RANK_SECONDARY,
       GST_TYPE_QTKIT_VIDEO_SRC);
 #endif
-- 
cgit v0.10.2

