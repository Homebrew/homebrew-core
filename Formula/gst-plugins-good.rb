class GstPluginsGood < Formula
  desc "GStreamer plugins (well-supported, under the LGPL)"
  homepage "https://gstreamer.freedesktop.org/"
  revision 1

  stable do
    url "https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.8.3.tar.xz"
    sha256 "a1d6579ba203a7734927c24b90bf6590d846c5a5fcec01a48201018c8ad2827a"

    # Fix build on Sierra. https://bugzilla.gnome.org/show_bug.cgi?id=770526
    # Unlike upstream commit, don't touch Makefile.am.
    patch :DATA

    depends_on "check" => :optional
  end

  bottle do
    sha256 "987a604513d8a895ed5bf8bab648fb55612ad796dd4d3998833cdb10c2b55633" => :sierra
    sha256 "5e6bf6bbb342160ff6fdd31133b885a77574b201e5ffdcd69f4234e3ae493be5" => :el_capitan
    sha256 "382137a757d26549d2a7da215e44fd71244a89e4a33b1c84c7f7182827d41b3c" => :yosemite
    sha256 "91c6a4ef3a2801d1843e4170e39d40281cdf9c24c34363fee4fb8e3e4d8e8cea" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-good.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "check"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "libsoup"

  depends_on :x11 => :optional

  # Dependencies based on the intersection of
  # https://cgit.freedesktop.org/gstreamer/gst-plugins-good/tree/REQUIREMENTS
  # and Homebrew formulae.
  depends_on "jpeg" => :recommended
  depends_on "orc" => :recommended
  depends_on "gdk-pixbuf" => :optional
  depends_on "aalib" => :optional
  depends_on "cairo" => :optional
  depends_on "flac" => [:optional, "with-libogg"]
  depends_on "libcaca" => :optional
  depends_on "libdv" => :optional
  depends_on "libpng" => :optional
  depends_on "libshout" => :optional
  depends_on "speex" => :optional
  depends_on "taglib" => :optional

  depends_on "libvpx" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "jack" => :optional

  depends_on "libogg" if build.with? "flac"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-gtk-doc
      --disable-goom
      --with-default-videosink=ximagesink
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    if build.with? "x11"
      args << "--with-x"
    else
      args << "--disable-x"
    end

    # This plugin causes hangs on Snow Leopard (and possibly other versions?)
    # Upstream says it hasn't "been actively tested in a long time";
    # successor is glimagesink (in gst-plugins-bad).
    # https://bugzilla.gnome.org/show_bug.cgi?id=756918
    if MacOS.version == :snow_leopard
      args << "--disable-osx_video"
    end

    if build.head?
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin cairo")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/sys/osxvideo/cocoawindow.h b/sys/osxvideo/cocoawindow.h
index 9355d3c..816f1bb 100644
--- a/sys/osxvideo/cocoawindow.h
+++ b/sys/osxvideo/cocoawindow.h
@@ -27,7 +27,6 @@
  */
 
 #import <Cocoa/Cocoa.h>
-#import <QuickTime/QuickTime.h>
 #import <glib.h>
 #import <gst/video/navigation.h>
 
diff --git a/sys/osxvideo/osxvideosink.h b/sys/osxvideo/osxvideosink.h
index 2bf5d25..d467b0e 100644
--- a/sys/osxvideo/osxvideosink.h
+++ b/sys/osxvideo/osxvideosink.h
@@ -35,7 +35,6 @@
 #include <objc/runtime.h>
 #include <Cocoa/Cocoa.h>
 
-#include <QuickTime/QuickTime.h>
 #import "cocoawindow.h"
 
 GST_DEBUG_CATEGORY_EXTERN (gst_debug_osx_video_sink);
