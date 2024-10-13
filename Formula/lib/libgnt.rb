class Libgnt < Formula
  desc "NCurses toolkit for creating text-mode graphical user interfaces"
  homepage "https://keep.imfreedom.org/libgnt/libgnt"
  url "https://downloads.sourceforge.net/project/pidgin/libgnt/2.14.3/libgnt-2.14.3.tar.xz"
  sha256 "57f5457f72999d0bb1a139a37f2746ec1b5a02c094f2710a339d8bcea4236123"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://sourceforge.net/projects/pidgin/rss?path=/libgnt"
    regex(%r{url=.*?/libgnt[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "06e99df7a279d7a4f75274f96a0db2f6afe0c6b234bbc92d967f289d001cc4c5"
    sha256 cellar: :any, arm64_sonoma:   "92cb079a6648bbd97c733c00ab6d0ca2bbaa10fa07dd7edafe0e467d59cd928d"
    sha256 cellar: :any, arm64_ventura:  "cef0929d73436e28d17b5373a7088b7cbebddb53cd2aa5ae332e8b3c7264b2d5"
    sha256 cellar: :any, arm64_monterey: "0345644c556d7cca3a1974f1d716ca906b3a9819122b8832af2f5fe436febe44"
    sha256 cellar: :any, sonoma:         "b935c28f5db2f8b807c8550f02eb766793bf324a7b6beaa5f7e83b4dd4671e37"
    sha256 cellar: :any, ventura:        "9e74dedfc9bc7dd2d44936fa08782aa46bf4e8b9fcf448ba6dfbab1390b229d5"
    sha256 cellar: :any, monterey:       "b8ee230409a87a54eb1739b0df20eb82c121d0a6d53674b2d8503476fd315b27"
    sha256               x86_64_linux:   "a1aeee55bd6025c795083d7889415358ab4241b74bc37cd7392833e971eae98d"
  end

  depends_on "gtk-doc" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "ncurses"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  # build patch for ncurses 6
  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    # upstream bug report on this workaround, https://issues.imfreedom.org/issue/LIBGNT-15
    inreplace "meson.build", "ncurses_sys_prefix = '/usr'",
                             "ncurses_sys_prefix = '#{Formula["ncurses"].opt_prefix}'"

    system "meson", "setup", "build", "-Dpython2=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gnt/gnt.h>

      int main() {
          gnt_init();
          gnt_quit();

          return 0;
      }
    EOS

    flags = [
      "-I#{Formula["glib"].opt_include}/glib-2.0",
      "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
      "-I#{include}",
      "-L#{lib}",
      "-L#{Formula["glib"].opt_lib}",
      "-lgnt",
      "-lglib-2.0",
    ]
    system ENV.cc, "test.c", *flags, "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/gntwm.c b/gntwm.c
index ffb1f4a..2ca4a6a 100644
--- a/gntwm.c
+++ b/gntwm.c
@@ -161,47 +161,49 @@ static void
 work_around_for_ncurses_bug(void)
 {
 #ifndef NO_WIDECHAR
-	PANEL *panel = NULL;
-	while ((panel = panel_below(panel)) != NULL) {
-		int sx, ex, sy, ey, w, y;
-		cchar_t ch;
-		PANEL *below = panel;
-
-		sx = getbegx(panel->win);
-		ex = getmaxx(panel->win) + sx;
-		sy = getbegy(panel->win);
-		ey = getmaxy(panel->win) + sy;
-
-		while ((below = panel_below(below)) != NULL) {
-			if (sy > getbegy(below->win) + getmaxy(below->win) ||
-					ey < getbegy(below->win))
-				continue;
-			if (sx > getbegx(below->win) + getmaxx(below->win) ||
-					ex < getbegx(below->win))
-				continue;
-			for (y = MAX(sy, getbegy(below->win)); y <= MIN(ey, getbegy(below->win) + getmaxy(below->win)); y++) {
-				if (mvwin_wch(below->win, y - getbegy(below->win), sx - 1 - getbegx(below->win), &ch) != OK)
-					goto right;
-				w = widestringwidth(ch.chars);
-				if (w > 1 && (ch.attr & 1)) {
-					ch.chars[0] = ' ';
-					ch.attr &= ~ A_CHARTEXT;
-					mvwadd_wch(below->win, y - getbegy(below->win), sx - 1 - getbegx(below->win), &ch);
-					touchline(below->win, y - getbegy(below->win), 1);
-				}
+    PANEL *panel = NULL;
+    while ((panel = panel_below(panel)) != NULL) {
+        int sx, ex, sy, ey, w, y;
+        cchar_t ch;
+        PANEL *below = panel;
+        WINDOW *panel_win = panel_window(panel);
+
+        sx = getbegx(panel_win);
+        ex = getmaxx(panel_win) + sx;
+        sy = getbegy(panel_win);
+        ey = getmaxy(panel_win) + sy;
+
+        while ((below = panel_below(below)) != NULL) {
+            WINDOW *below_win = panel_window(below);
+            if (sy > getbegy(below_win) + getmaxy(below_win) ||
+                    ey < getbegy(below_win))
+                continue;
+            if (sx > getbegx(below_win) + getmaxx(below_win) ||
+                    ex < getbegx(below_win))
+                continue;
+            for (y = MAX(sy, getbegy(below_win)); y <= MIN(ey, getbegy(below_win) + getmaxy(below_win)); y++) {
+                if (mvwin_wch(below_win, y - getbegy(below_win), sx - 1 - getbegx(below_win), &ch) != OK)
+                    goto right;
+                w = widestringwidth(ch.chars);
+                if (w > 1 && (ch.attr & 1)) {
+                    ch.chars[0] = ' ';
+                    ch.attr &= ~ A_CHARTEXT;
+                    mvwadd_wch(below_win, y - getbegy(below_win), sx - 1 - getbegx(below_win), &ch);
+                    touchline(below_win, y - getbegy(below_win), 1);
+                }
 right:
-				if (mvwin_wch(below->win, y - getbegy(below->win), ex + 1 - getbegx(below->win), &ch) != OK)
-					continue;
-				w = widestringwidth(ch.chars);
-				if (w > 1 && !(ch.attr & 1)) {
-					ch.chars[0] = ' ';
-					ch.attr &= ~ A_CHARTEXT;
-					mvwadd_wch(below->win, y - getbegy(below->win), ex + 1 - getbegx(below->win), &ch);
-					touchline(below->win, y - getbegy(below->win), 1);
-				}
-			}
-		}
-	}
+                if (mvwin_wch(below_win, y - getbegy(below_win), ex + 1 - getbegx(below_win), &ch) != OK)
+                    continue;
+                w = widestringwidth(ch.chars);
+                if (w > 1 && !(ch.attr & 1)) {
+                    ch.chars[0] = ' ';
+                    ch.attr &= ~ A_CHARTEXT;
+                    mvwadd_wch(below_win, y - getbegy(below_win), ex + 1 - getbegx(below_win), &ch);
+                    touchline(below_win, y - getbegy(below_win), 1);
+                }
+            }
+        }
+    }
 #endif
 }

@@ -2287,5 +2289,3 @@ void gnt_wm_set_event_stack(GntWM *wm, gboolean set)
 {
 	wm->event_stack = set;
 }
-
-
