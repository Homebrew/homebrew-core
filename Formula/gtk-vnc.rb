class GtkVnc < Formula
  desc "VNC viewer widget for GTK"
  homepage "https://wiki.gnome.org/Projects/gtk-vnc"
  url "https://download.gnome.org/sources/gtk-vnc/1.2/gtk-vnc-1.2.0.tar.xz"
  sha256 "7aaf80040d47134a963742fb6c94e970fcb6bf52dc975d7ae542b2ef5f34b94a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_monterey: "145945a233cb938e7f0171ad9339b11ef1d61a9f19af72201c12d7305175b50c"
    sha256 arm64_big_sur:  "b07922526eaea0881a6394907b9cc332fc37852c5206a92692468243d13a2ac8"
    sha256 monterey:       "80799a6281038d4100a8709fc45a69c891d937a681385fe4fdd32dc2c478777b"
    sha256 big_sur:        "f4961c57ac8d69639f2f0a95d307ec85b0cee23f204666989853382158bf8986"
    sha256 catalina:       "16cc1407520b9b5a6454507e1db7f7226d78320c353cd9f45130c9ba7883567c"
    sha256 mojave:         "218453c1fa7ae8b188ecbfe0ca408beefff3fbf168fa1fdd397ac73c4336c031"
    sha256 x86_64_linux:   "9ac4316ffc6dca96ef488bac50dae54d5a733f9bdd4f11da945fc90fc2f47981"
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
  # https://gitlab.gnome.org/GNOME/gtk-vnc/-/issues/16
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
