class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.2/gtk-vnc-1.2.0.tar.xz"
  sha256 "7aaf80040d47134a963742fb6c94e970fcb6bf52dc975d7ae542b2ef5f34b94a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "c4d93c7478a2c290005613240d088189785560435f8c4aa3031ec5af6c1196a3"
    sha256 big_sur:       "959cf4a7bac1fee4f17fd571222b6bff7a3aa6b172b3abcc7af3088cd927b699"
    sha256 catalina:      "f6e79e525133ea8c72d4be4b0719299141a8b206b9f547fd27b882b06a817f01"
    sha256 mojave:        "1e932ef0f54e09e9cf107c6ef386ff49e1b1cfd107eca77e4d1c5569da71909d"
    sha256 high_sierra:   "efb82f38076361165896bbf906881331c349082464fa8fc0b6b81f4c58b52f0a"
    sha256 sierra:        "c244ffda67d3e559172ba2b9e2b1015011733630232c203f733f259d8a6dd485"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libgcrypt"

  # Fix configuration failure with -Dwith-vala=disabled
  # Remove in the next release.
  patch do
    url "https://gitlab.gnome.org/GNOME/gtk-vnc/-/commit/bdab05584bab5c2ecdd508df49b03e80aedd19fc.diff"
    sha256 "1b260157be888d9d8e6053e6cfd7ae92a666c306f04f4f23a0a1ed68a06c777d"
  end

  # Fix compile failure in src/vncdisplaykeymap.c
  # error: implicit declaration of function 'GDK_IS_QUARTZ_DISPLAY' is invalid in C99
  patch :DATA

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dwith-vala=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/gvnccapture", "--help"
  end
end

__END__
diff --git a/src/vncdisplaykeymap.c b/src/vncdisplaykeymap.c
index 9c029af..8d3ec20 100644
--- a/src/vncdisplaykeymap.c
+++ b/src/vncdisplaykeymap.c
@@ -69,6 +69,8 @@
 #endif
 
 #ifdef GDK_WINDOWING_QUARTZ
+#include <gdk/gdkquartz.h>
+
 /* OS-X native keycodes */
 #include "vncdisplaykeymap_osx2qnum.h"
 #endif
