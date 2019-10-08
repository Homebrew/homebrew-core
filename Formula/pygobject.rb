class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://wiki.gnome.org/Projects/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.7.tar.xz"
  sha256 "bb9d25a3442ca7511385a7c01b057492095c263784ef31231ffe589d83a96a5a"
  revision 2

  bottle do
    cellar :any
    sha256 "2dbdab3cd94b10eae121c1e8460085b84c1908b487150e486005dd125f99890d" => :catalina
    sha256 "caf4b79e8454b58bb67e73a6f06853d7a410c1fa9b31478c6ac389424ca690bb" => :mojave
    sha256 "04550d558f335fd6431ee3c124ba19011ec4284e7584eff343ad6b78483472a5" => :high_sierra
    sha256 "fbe187ff2aa28f4e9f57e1e3f8f69df8e69da6406833b3dd9a976f5bae267ee7" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "python@2"

  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<~EOS
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system Formula["python@2"].opt_bin/"python2.7", "-c", "import dsextras"
  end
end

__END__
diff --git a/gio/unix-types.defs b/gio/unix-types.defs
index ed1ed9f..3f51436 100644
--- a/gio/unix-types.defs
+++ b/gio/unix-types.defs
@@ -7,18 +7,6 @@
   (gtype-id "G_TYPE_UNIX_CONNECTION")
 )

-(define-object DesktopAppInfo
-  (docstring
-  "DesktopAppInfo(desktop_id) -> gio.unix.DesktopAppInfo\n\n"
-  "gio.Unix.DesktopAppInfo is an implementation of gio.AppInfo\n"
-  "based on desktop files."
-  )
-  (in-module "giounix")
-  (parent "GObject")
-  (c-name "GDesktopAppInfo")
-  (gtype-id "G_TYPE_DESKTOP_APP_INFO")
-)
-
 (define-object FDMessage
   (in-module "giounix")
   (parent "GSocketControlMessage")
diff --git a/gio/unix.defs b/gio/unix.defs
index ff43ed6..4c28b92 100644
--- a/gio/unix.defs
+++ b/gio/unix.defs
@@ -32,52 +32,6 @@



-;; From gdesktopappinfo.h
-
-(define-function desktop_app_info_get_type
-  (c-name "g_desktop_app_info_get_type")
-  (return-type "GType")
-)
-
-(define-function desktop_app_info_new_from_filename
-  (c-name "g_desktop_app_info_new_from_filename")
-  (return-type "GDesktopAppInfo*")
-  (parameters
-    '("const-char*" "filename")
-  )
-)
-
-(define-function g_desktop_app_info_new_from_keyfile
-  (c-name "g_desktop_app_info_new_from_keyfile")
-  (return-type "GDesktopAppInfo*")
-  (parameters
-    '("GKeyFile*" "key_file")
-  )
-)
-
-(define-function desktop_app_info_new
-  (c-name "g_desktop_app_info_new")
-  (is-constructor-of "GDesktopAppInfo")
-  (return-type "GDesktopAppInfo*")
-  (parameters
-    '("const-char*" "desktop_id")
-  )
-)
-
-(define-method get_is_hidden
-  (of-object "GDesktopAppInfo")
-  (c-name "g_desktop_app_info_get_is_hidden")
-  (return-type "gboolean")
-)
-
-(define-function desktop_app_info_set_desktop_env
-  (c-name "g_desktop_app_info_set_desktop_env")
-  (return-type "none")
-  (parameters
-    '("const-char*" "desktop_env")
-  )
-)
-


 ;; From gunixfdmessage.h
diff --git a/gio/unix.override b/gio/unix.override
index aebc6fc..08e27e9 100644
--- a/gio/unix.override
+++ b/gio/unix.override
@@ -24,7 +24,6 @@ headers
 #define NO_IMPORT_PYGOBJECT
 #include <pygobject.h>
 #include <gio/gio.h>
-#include <gio/gdesktopappinfo.h>
 #include <gio/gunixinputstream.h>
 #include <gio/gunixmounts.h>
 #include <gio/gunixoutputstream.h>
