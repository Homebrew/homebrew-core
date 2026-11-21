class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://putty.software/"
  url "https://the.earth.li/~sgtatham/putty/0.85/putty-0.85.tar.gz"
  sha256 "13fd4db2936d03b73812a7bcc2a658e4dd29cc776a56c3670a7fc6f1a0ee8af8"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "884b067f71a01693f144585ab385120d0d5003ba388db9f93573d54db8af7099"
    sha256 cellar: :any, arm64_tahoe:       "a4e421f1fa6345d1ac144df17dde9b51ed850ccf2f455f78c425745e18893e24"
    sha256 cellar: :any, arm64_sequoia:     "9827f9974dab6b05e1cd8afc5b54332a91f2b070b5011452c6358631e21fa3bd"
    sha256 cellar: :any, arm64_sonoma:      "7926b63799e359c16920b4adc709349d7643f0e3c3d8a5b5593272df227646e7"
    sha256 cellar: :any, sonoma:            "be46bf5d09cb2255f9c31c8bb223cef56c368007c89ada9697d96bb1bac5b767"
    sha256 cellar: :any, arm64_linux:       "6efe8b3b257063721dfd653918a6f449bf711d859dbc68abc8151847a4a8e5cc"
    sha256 cellar: :any, x86_64_linux:      "6f2d73f3c6e67b86e2cab8dbc634c6389267f0ea693802af27f5615e701a4e46"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxrender"
  end

  conflicts_with "plink1", because: "both install a `plink` binary"
  conflicts_with "pssh", because: "both install `pscp` binaries"

  # Upstream wishlist item: https://www.chiark.greenend.org.uk/~sgtatham/putty/wishlist/port-mac.html
  # Submitted to putty@projects.tartarus.org
  patch :DATA

  def install
    args = ["-DPUTTY_GTK_VERSION=3"]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # to reduce overlinking

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "expect"
    require "pty"

    PTY.spawn(bin/"puttygen", "-t", "rsa", "-b", "4096", "-q", "-o", "test.key") do |r, w, _pid|
      r.expect "Enter passphrase to save key: "
      w.write "Homebrew\n"
      r.expect "Re-enter passphrase to verify: "
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_path_exists testpath/"test.key"
  end
end

__END__
diff --git a/cmake/platforms/unix.cmake b/cmake/platforms/unix.cmake
index 4ae8c31..c4291df 100644
--- a/cmake/platforms/unix.cmake
+++ b/cmake/platforms/unix.cmake
@@ -117,6 +117,19 @@ add_optional_system_lib(m pow)
 add_optional_system_lib(rt clock_gettime)
 add_optional_system_lib(xnet socket)
 
+if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
+  # macOS (including Apple Silicon machines) needs a number of
+  # workarounds in the front-end code, because its GTK does not speak
+  # X11 and its keyboard has a Command key. They are all enabled by
+  # this one define; see the comment at the top of unix/platform.h.
+  add_definitions(-DOSX_GTK)
+  # The front-end code talks to AppKit via the Objective-C runtime
+  # interface (see utils/our_dialog.c), so we must link libobjc
+  # ourselves: it's implicit for Objective-C source files, but we
+  # use it from plain C.
+  add_optional_system_lib(objc objc_getClass)
+endif()
+
 set(extra_dirs charset)
 
 if(PUTTY_GSSAPI STREQUAL DYNAMIC)
diff --git a/terminal/terminal.c b/terminal/terminal.c
index c2cb311..fec5657 100644
--- a/terminal/terminal.c
+++ b/terminal/terminal.c
@@ -6184,8 +6184,17 @@ static void do_paint(Terminal *term)
                 tchar = term->ucsdata->unitab_scoacs[tchar&0xFF];
                 break;
             }
+            /* A wide-character pair must not be allowed to straddle the
+             * boundary of the pre-edit text: the cells covered by the
+             * pre-edit are not displayed from the underlying line, and
+             * pairing across the boundary can contradict the cursor
+             * placement computed above, tripping an assertion in the
+             * second loop when the cursor is placed at the start of the
+             * pre-edit region. */
             if (j < (in_preedit ? preedit_end : term->cols) - 1
-                && d[1].chr == UCSWIDE)
+                && d[1].chr == UCSWIDE
+                && (in_preedit || j + 1 < preedit_start ||
+                    j >= preedit_end))
                 tattr |= ATTR_WIDE;
 
             /* Video reversing things */
@@ -8180,6 +8189,16 @@ void term_set_preedit_text(Terminal *term, char *preedit_text)
                 break;
             }
         }
+        if (width == 0) {
+            /* If the pre-edit string had nothing visible in it, don't
+             * store a zero-width preedit_termline at all. do_paint()
+             * looks at the line's last character when placing the
+             * cursor, which would be an out-of-bounds read on such a
+             * line, and the resulting cursor-position adjustment can
+             * provoke an assertion failure during painting. */
+            freetermline(term->preedit_termline);
+            term->preedit_termline = NULL;
+        }
     }
     seen_disp_event(term);
 }
diff --git a/unix/dialog.c b/unix/dialog.c
index e298963..7b7f558 100644
--- a/unix/dialog.c
+++ b/unix/dialog.c
@@ -3302,6 +3302,15 @@ GtkWidget *create_config_box(const char *title, Conf *conf,
 
     gtk_window_set_position(GTK_WINDOW(window), GTK_WIN_POS_CENTER);
     gtk_widget_show(window);
+#ifdef __APPLE__
+    /*
+     * This is probably the first window this process will ever
+     * show, so we must make sure it comes to the front: with the
+     * Quartz GDK backend it would otherwise appear behind those of
+     * whichever application was frontmost when we were started up.
+     */
+    our_window_show_frontmost(window);
+#endif
 
     /*
      * Set focus into the first available control.
diff --git a/unix/gtkmisc.h b/unix/gtkmisc.h
index 3d2d1f3..3a3ac3a 100644
--- a/unix/gtkmisc.h
+++ b/unix/gtkmisc.h
@@ -16,4 +16,6 @@ void our_dialog_add_to_content_area(GtkWindow *dlg, GtkWidget *w,
 void our_dialog_set_action_area(GtkWindow *dlg, GtkWidget *w);
 GtkBox *our_dialog_make_action_hbox(GtkWindow *dlg);
 
+void our_window_show_frontmost(GtkWidget *window);
+
 #endif /* PUTTY_GTKMISC_H */
diff --git a/unix/platform.h b/unix/platform.h
index a7efafd..5f04235 100644
--- a/unix/platform.h
+++ b/unix/platform.h
@@ -45,6 +45,20 @@
 
 #endif
 
+#if defined __APPLE__ && !defined JUST_USE_GTK_CLIPBOARD_UTF8
+/*
+ * Even if we didn't configure with OSX_GTK (which no build system
+ * does any more), the GTK that we link against on OS X is built
+ * with the native Cocoa (Quartz) GDK backend. There, the
+ * low-level gdk_selection_* / gtk_selection_* mechanism has no
+ * bridge to the system clipboard at all, so use the high-level
+ * GtkClipboard API instead, which maps onto NSPasteboard. This is
+ * the same reason the historical OSX_GTK builds defined this
+ * macro.
+ */
+#define JUST_USE_GTK_CLIPBOARD_UTF8
+#endif
+
 /* BUILDINFO_PLATFORM varies its expansion between the GTK and
  * pure-CLI utilities, so that Unix Plink, PSFTP etc don't announce
  * themselves incongruously as having something to do with GTK. */
@@ -118,13 +132,16 @@ unsigned long getticks(void);
 #define CLIPNAME_IMPLICIT "Last selected text"
 #define CLIPNAME_EXPLICIT "System clipboard"
 #define CLIPNAME_EXPLICIT_OBJECT "system clipboard"
-/* These defaults are the ones that more or less comply with the OS X
- * Human Interface Guidelines, i.e. copy/paste to the system clipboard
- * is _not_ implicit but requires a specific UI action. This is at
- * odds with all other PuTTY front ends' defaults, but on OS X there
- * is no multi-decade precedent for PuTTY working the other way. */
-#define CLIPUI_DEFAULT_AUTOCOPY false
-#define CLIPUI_DEFAULT_MOUSE CLIPUI_IMPLICIT
+/*
+ * Copy/paste via the system clipboard is available both by explicit
+ * action (Command-C/V, and of course the menu items) and by
+ * ordinary mouse action: selecting text copies to the system
+ * clipboard, and the paste button (middle, as ever) pastes from
+ * it. This matches what the Windows front end does, and what most
+ * Mac terminal emulators do too.
+ */
+#define CLIPUI_DEFAULT_AUTOCOPY true
+#define CLIPUI_DEFAULT_MOUSE CLIPUI_EXPLICIT
 #define CLIPUI_DEFAULT_INS CLIPUI_EXPLICIT
 #define MENU_CLIPBOARD CLIP_CLIPBOARD
 #define COPYALL_CLIPBOARDS CLIP_CLIPBOARD
@@ -138,6 +155,22 @@ unsigned long getticks(void);
  * it was first thought of in 2002 */
 #define CLIPUI_DEFAULT_AUTOCOPY false
 #define CLIPUI_DEFAULT_MOUSE CLIPUI_IMPLICIT
+#ifdef __APPLE__
+/*
+ * On OS X, the X11 PRIMARY selection is invisible to the system
+ * pasteboard: CLIPBOARD is the clipboard which gets bridged to
+ * it (directly to NSPasteboard on the Cocoa GDK backend, or via
+ * XQuartz if you run the X11 one). So by default, mouse
+ * selection also copies to CLIPBOARD, and the mouse paste action
+ * pastes from CLIPBOARD instead. The mouse button assignments
+ * themselves are unchanged: left to select, middle to paste,
+ * right to extend.
+ */
+#undef CLIPUI_DEFAULT_AUTOCOPY
+#undef CLIPUI_DEFAULT_MOUSE
+#define CLIPUI_DEFAULT_AUTOCOPY true
+#define CLIPUI_DEFAULT_MOUSE CLIPUI_EXPLICIT
+#endif
 #define CLIPUI_DEFAULT_INS CLIPUI_IMPLICIT
 #define MENU_CLIPBOARD CLIP_CLIPBOARD
 #define COPYALL_CLIPBOARDS CLIP_PRIMARY, CLIP_CLIPBOARD
diff --git a/unix/utils/our_dialog.c b/unix/utils/our_dialog.c
index 0ca8a7d..be28a11 100644
--- a/unix/utils/our_dialog.c
+++ b/unix/utils/our_dialog.c
@@ -37,6 +37,12 @@
 #include "gtkcompat.h"
 #include "gtkmisc.h"
 
+#ifdef __APPLE__
+#include <objc/objc.h>
+#include <objc/runtime.h>
+#include <objc/message.h>
+#endif
+
 GtkWidget *our_dialog_new(void)
 {
 #if GTK_CHECK_VERSION(3,0,0)
@@ -133,3 +139,42 @@ void our_dialog_add_to_content_area(GtkWindow *dlg, GtkWidget *w,
         w, expand, fill, padding);
 #endif
 }
+
+/*
+ * Present a window that we've just shown, in such a way that it
+ * comes to the front of everything else on screen.
+ *
+ * On OS X, presenting the window within our own application isn't
+ * enough if that application isn't itself frontmost: the window
+ * will still appear behind the windows of whichever application
+ * is. The Quartz GDK backend only makes the application frontmost
+ * when the user clicks on one of our windows, which is no help
+ * for the first window we ever show - such as the configuration
+ * box at startup - so we must ask AppKit ourselves. We use the
+ * Objective-C runtime interface to call the sharedApplication's
+ * activateIgnoringOtherApps: method, because this file, like all
+ * the others in here, is plain C.
+ */
+void our_window_show_frontmost(GtkWidget *window)
+{
+#if GTK_CHECK_VERSION(2,0,0)
+    gtk_window_present(GTK_WINDOW(window));
+#endif
+
+#ifdef __APPLE__
+    Class nsapplication = objc_getClass("NSApplication");
+
+    if (nsapplication) {
+        id (*send_shared_application)(Class, SEL) =
+            (id (*)(Class, SEL))objc_msgSend;
+        void (*send_activate)(id, SEL, int) =
+            (void (*)(id, SEL, int))objc_msgSend;
+
+        id app = send_shared_application(
+            nsapplication, sel_registerName("sharedApplication"));
+        if (app)
+            send_activate(app,
+                          sel_registerName("activateIgnoringOtherApps:"), 1);
+    }
+#endif
+}
diff --git a/unix/window.c b/unix/window.c
index 006850e..35f645c 100644
--- a/unix/window.c
+++ b/unix/window.c
@@ -144,6 +144,13 @@ struct GtkFrontend {
     BusyStatus busy_status;
     int alt_keycode;
     int alt_digits;
+#ifdef __APPLE__
+    /* True while the OS X Command key is the modifier currently
+     * held down: it's the one that presents itself as
+     * Meta_L/Meta_R on both the Cocoa and XQuartz GDK backends,
+     * whereas the Option key presents itself as Alt_L/Alt_R */
+    bool command_key_held;
+#endif
     char *wintitle;
     char *icontitle;
     int master_fd, master_func_id;
@@ -1040,6 +1047,66 @@ static int return_key(GtkFrontend *inst, char *output, bool *special)
     return end;
 }
 
+#ifdef __APPLE__
+/*
+ * Subroutine of key_event: implement Command-C and Command-V copy
+ * and paste via the system clipboard, as OS X users expect.
+ *
+ * The Command key is the one that presents itself as the modifier
+ * keysyms Meta_L/Meta_R on both GDK backends available on OS X
+ * (native Cocoa, or X11 under XQuartz), whereas the Option key
+ * presents itself as Alt_L/Alt_R. On the plain build we therefore
+ * check the command_key_held flag maintained in key_event below,
+ * so that Option keeps its usual Meta behaviour; the required
+ * modifier bit on the key event depends on the backend: MOD2 on
+ * the native Cocoa one, MOD1 under XQuartz, MOD4 if the user has
+ * reconfigured Command as Super.
+ *
+ * In the build with configurable Meta keys, the Command key is
+ * normally the 'system' modifier, and key events carrying it
+ * reach us here only because we haven't yet swallowed them for
+ * letting GTK deal with them; if the user has configured Command
+ * as a second Meta key instead, then system_mod_mask is zero for
+ * it and we leave Command-C/V to be handled as Meta.
+ *
+ * We copy to and paste from CLIPBOARD, because that's the
+ * clipboard which gets bridged to the OS X system pasteboard;
+ * PRIMARY does not.
+ */
+static bool command_key_copy_paste(GtkFrontend *inst, GdkEventKey *event)
+{
+    if (event->type != GDK_KEY_PRESS ||
+        !(event->keyval == GDK_KEY_c || event->keyval == GDK_KEY_C ||
+          event->keyval == GDK_KEY_v || event->keyval == GDK_KEY_V) ||
+        (event->state & GDK_CONTROL_MASK))
+        return false;
+
+#ifdef OSX_META_KEY_CONFIG
+    if (!(event->state & inst->system_mod_mask))
+        return false;
+#else
+    if (!(inst->command_key_held &&
+          (event->state & (GDK_MOD1_MASK | GDK_MOD2_MASK |
+                           GDK_MOD4_MASK))))
+        return false;
+#endif
+
+    if (event->keyval == GDK_KEY_v || event->keyval == GDK_KEY_V) {
+#ifdef KEY_EVENT_DIAGNOSTICS
+        debug(" - Command-V: paste from CLIPBOARD\n");
+#endif
+        term_request_paste(inst->term, CLIP_CLIPBOARD);
+    } else {
+        static const int clips[] = { CLIP_CLIPBOARD };
+#ifdef KEY_EVENT_DIAGNOSTICS
+        debug(" - Command-C: copy to CLIPBOARD\n");
+#endif
+        term_request_copy(inst->term, clips, lenof(clips));
+    }
+    return true;
+}
+#endif /* __APPLE__ */
+
 gint key_event(GtkWidget *widget, GdkEventKey *event, gpointer data)
 {
     GtkFrontend *inst = (GtkFrontend *)data;
@@ -1054,6 +1121,11 @@ gint key_event(GtkWidget *widget, GdkEventKey *event, gpointer data)
 
     noise_ultralight(NOISE_SOURCE_KEY, event->keyval);
 
+#ifdef __APPLE__
+    if (command_key_copy_paste(inst, event))
+        return true;
+#endif
+
 #ifdef OSX_META_KEY_CONFIG
     if (event->state & inst->system_mod_mask)
         return false;                  /* let GTK process OS X Command key */
@@ -1156,6 +1228,20 @@ gint key_event(GtkWidget *widget, GdkEventKey *event, gpointer data)
      * character code.
      */
     if (event->type == GDK_KEY_RELEASE) {
+#ifdef __APPLE__
+        /*
+         * If one of the Meta-ish modifier keys has just been
+         * released, then the Command key can't be held down any
+         * more.
+         */
+        if (event->keyval == GDK_KEY_Meta_L ||
+            event->keyval == GDK_KEY_Meta_R ||
+            event->keyval == GDK_KEY_Super_L ||
+            event->keyval == GDK_KEY_Super_R ||
+            event->keyval == GDK_KEY_Alt_L ||
+            event->keyval == GDK_KEY_Alt_R)
+            inst->command_key_held = false;
+#endif
         if ((event->keyval == GDK_KEY_Meta_L ||
              event->keyval == GDK_KEY_Meta_R ||
              event->keyval == GDK_KEY_Alt_L ||
@@ -1192,6 +1278,25 @@ gint key_event(GtkWidget *widget, GdkEventKey *event, gpointer data)
     }
 
     if (event->type == GDK_KEY_PRESS) {
+#ifdef __APPLE__
+        /*
+         * Track which of the Meta-ish modifier keys is currently
+         * down. On OS X, the Command key is the one that presents
+         * itself as Meta_L/Meta_R, on both the Cocoa GDK backend
+         * (as linked against e.g. by Homebrew builds) and the X11
+         * one under XQuartz, whereas the Option key presents
+         * itself as Alt_L/Alt_R. Accept Super_L/Super_R as
+         * Command-ish too, in case of a user reconfiguration.
+         */
+        if (event->keyval == GDK_KEY_Meta_L ||
+            event->keyval == GDK_KEY_Meta_R ||
+            event->keyval == GDK_KEY_Super_L ||
+            event->keyval == GDK_KEY_Super_R)
+            inst->command_key_held = true;
+        else if (event->keyval == GDK_KEY_Alt_L ||
+                 event->keyval == GDK_KEY_Alt_R)
+            inst->command_key_held = false;
+#endif
         /*
          * If Alt has just been pressed, we start potentially
          * accumulating an Alt+numberpad code. We do this by
@@ -2977,7 +3082,7 @@ static void clipboard_text_received(GtkClipboard *clipboard,
     if (!text)
         return;
 
-    paste = dup_mb_to_wc(CS_UTF8, text, length, &paste_len);
+    paste = dup_mb_to_wc_c(CS_UTF8, text, strlen(text), &paste_len);
 
     term_do_paste(inst->term, paste, paste_len);
 
@@ -5622,6 +5727,17 @@ void new_session_window(Conf *conf, const char *geometry_string)
     set_window_icon(inst->window, ALL_ICONS(main_icon), N_ICONS(main_icon));
 
     gtk_widget_show(inst->window);
+#ifdef __APPLE__
+    /*
+     * If this is the first window this process will ever show
+     * (i.e. we've been launched directly into a session rather
+     * than via the configuration box), ask for it to come to the
+     * front of the whole screen; otherwise the Quartz GDK backend
+     * may leave it behind the windows of whatever application we
+     * were started from.
+     */
+    our_window_show_frontmost(inst->window);
+#endif
 
     set_window_background(inst);
 
