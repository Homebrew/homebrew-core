class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "http://gsmartcontrol.sourceforge.net/home/index.php"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/0.8.7/gsmartcontrol-0.8.7.tar.bz2"
  sha256 "708fa803243abb852ed52050fc82cd3592a798c02743342441996e77f19ffec6"
  revision 2

  bottle do
    sha256 "74418f9a4fd88bb957d1c10725ffc509b9955075646b7ac0b18d9ef3c65730b4" => :sierra
    sha256 "1d5d9c1007c083f8806a6243eca3907c16986d667bdca947379d95de409a4b2c" => :el_capitan
    sha256 "adf4259a04f10319300f83ffe55f309271490763af48dc8a02ab05cc1009b00f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "smartmontools"
  depends_on "gtkmm"
  depends_on "pcre"

  needs :cxx11

  # Fix bad includes with gtkmm-2.24.3
  # Check if this is still needed with new versions of gsmartcontrol and gtkmm
  patch :DATA

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gsmartcontrol", "--version"
  end
end

__END__
diff --git a/src/applib/cmdex_sync_gui.cpp b/src/applib/cmdex_sync_gui.cpp
index d253a17..83b2e11 100644
--- a/src/applib/cmdex_sync_gui.cpp
+++ b/src/applib/cmdex_sync_gui.cpp
@@ -9,6 +9,7 @@
 /// \weakgroup applib
 /// @{

+#include <glibmm.h>
 #include <gtkmm/main.h>  // Gtk::Main

 #include "hz/fs_path.h"
diff --git a/src/gsc_init.cpp b/src/gsc_init.cpp
index 0ded7bc..6fb1bb7 100644
--- a/src/gsc_init.cpp
+++ b/src/gsc_init.cpp
@@ -15,6 +15,7 @@
 #include <cstdio>  // std::printf
 #include <vector>
 #include <sstream>
+#include <glibmm.h>
 #include <gtkmm/main.h>
 #include <gtkmm/messagedialog.h>
 #include <gtk/gtk.h>  // gtk_window_set_default_icon_name, gtk_icon_theme_*
