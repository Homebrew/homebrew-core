class GnuTypist < Formula
  desc "GNU typing tutor"
  homepage "https://www.gnu.org/software/gtypist/"
  url "https://ftp.gnu.org/gnu/gtypist/gtypist-2.9.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/gtypist/gtypist-2.9.5.tar.xz"
  sha256 "c13af40b12479f8219ffa6c66020618c0ce305ad305590fde02d2c20eb9cf977"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "d5d21482cbcca6dbe6e311f9200daab62ab86752bb59ad28b83c63eec32d7754"
    sha256 arm64_sonoma:   "ec0daf0f5a1f0ceae0482b59a88ad8d24489c5d04334f36f052afff193dd47be"
    sha256 arm64_ventura:  "4ea5b5536d71dcce549c137487e1f253de1c65eb731cc96f96c6f840552538a2"
    sha256 arm64_monterey: "55bc014edf3a03938527035d043b5f993d9574e0b77a9ecd6d332eb4e8efcd18"
    sha256 sonoma:         "5994bfad16531f2491e6749b2bc1219f1a20e1f9c46713d3dedef188b66c00d8"
    sha256 ventura:        "63a4ab5d80a451ac4a64c4f8210d6fef5be03ed16ce91d121d3f6054f9b60dc9"
    sha256 monterey:       "9176597b6394a63864ef693f4815b74930a63f245a36b66656e9f203bf49d509"
    sha256 x86_64_linux:   "a992581b5efb631c92abb7b43ac1f126acb16fda1479beff3fd137276a04197f"
  end

  depends_on "gettext"

  uses_from_macos "ncurses"

  # patch based on upstream master to fix implicit declaration errors
  # we cannot use the commit directly since it doesn't apply cleanly on 2.9.5
  # https://git.savannah.gnu.org/cgit/gtypist.git/patch/?id=05639625b68131e648dfe2aec4dcc82ea6b95c6e
  patch :DATA

  # Use Apple's ncurses instead of ncursesw.
  # TODO: use an IFDEF for apple and submit upstream
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/42c4b96/gnu-typist/2.9.5.patch"
    sha256 "a408ecb8be3ffdc184fe1fa94c8c2a452f72b181ce9be4f72557c992508474db"
  end

  def install
    # libiconv is not linked properly without this
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    session = fork do
      exec bin/"gtypist", "-t", "-q", "-l", "DEMO_0", share/"gtypist/demo.typ"
    end
    sleep 2
    Process.kill("TERM", session)
  end
end

__END__
diff --git a/src/cursmenu.c b/src/cursmenu.c
index b52128b..f259f58 100644
--- a/src/cursmenu.c
+++ b/src/cursmenu.c
@@ -20,6 +20,7 @@
 #include "config.h"
 #include "cursmenu.h"
 #include "script.h"
+#include "utf8.h"
 
 #if defined(HAVE_PDCURSES) || defined(OS_BSD)
 #include <curses.h>
diff --git a/src/script.c b/src/script.c
index b2c29e5..540223b 100644
--- a/src/script.c
+++ b/src/script.c
@@ -18,6 +18,7 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+
 #include "config.h"
 #include "script.h"
 
@@ -227,15 +228,15 @@ void get_script_line( FILE *script, char *line )
       if (numChars == -1)
         fatal_error( _("Invalid multibyte sequence (wrong encoding?)"), line);
       if ( numChars < MIN_SCR_LINE )
-	fatal_error( _("data shortage"), line );
+        fatal_error( _("data shortage"), line );
       if ( SCR_SEP( line ) != C_SEP )
-	fatal_error( _("missing ':'"), line );
+        fatal_error( _("missing ':'"), line );
       if ( SCR_COMMAND( line ) != C_LABEL 
-	   && SCR_COMMAND( line ) != C_GOTO 
-	   && SCR_COMMAND( line ) != C_YGOTO
-	   && SCR_COMMAND( line ) != C_NGOTO
+           && SCR_COMMAND( line ) != C_GOTO 
+           && SCR_COMMAND( line ) != C_YGOTO
+           && SCR_COMMAND( line ) != C_NGOTO
            && utf8len(SCR_DATA( line )) > COLS )
-	fatal_error( _("line too long for screen"), line );
+        fatal_error( _("line too long for screen"), line );
     }
 }
 
diff --git a/src/script.h b/src/script.h
index 7db0eda..580b7ff 100644
--- a/src/script.h
+++ b/src/script.h
@@ -19,22 +19,23 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+
 #ifndef SCRIPT_H
 #define SCRIPT_H
 
 #include <stdio.h>
 
 /* things to help parse the input file */
-#define	SCR_COMMAND(X)		(X[0])
+#define	SCR_COMMAND(X)	(X[0])
 #define	SCR_SEP(X)		(X[1])
 #define	SCR_DATA(X)		(&X[2])
 #define	C_COMMENT		'#'
-#define	C_ALT_COMMENT		'!'
+#define	C_ALT_COMMENT	'!'
 #define	C_SEP			':'
 #define	C_CONT			' '
 #define	C_LABEL			'*'
 #define	C_TUTORIAL		'T'
-#define	C_INSTRUCTION		'I'
+#define	C_INSTRUCTION	'I'
 #define	C_CLEAR			'B'
 #define	C_GOTO			'G'
 #define	C_EXIT			'X'
@@ -73,7 +74,7 @@ extern char *__last_label;
 void __update_last_label (const char *);
 
 /* a global area for label indexing - singly linked lists, hashed */
-#define	NLHASH			32		/* num hash lists */
+#define	NLHASH			32	/* num hash lists */
 struct label_entry {
   char		*label;			/* label string */
   long		offset;			/* offset into file */
@@ -89,6 +90,7 @@ extern char *buffer_command( FILE *script, char *line );
 extern void seek_label( FILE *script, char *label, char *ref_line );
 extern int hash_label( char *label );
 extern void do_exit( FILE *script );
+void check_script_file_with_current_encoding( FILE *script );
 
 
 extern void bind_F12 (const char *);	// Defined in gtypist.c
diff --git a/src/utf8.c b/src/utf8.c
index e7c14c8..a9f355b 100644
--- a/src/utf8.c
+++ b/src/utf8.c
@@ -19,6 +19,7 @@
 
 #include "config.h"
 #include "utf8.h"
+#include "error.h"
 
 #if defined(HAVE_PDCURSES) || defined(OS_BSD)
 #include <curses.h>
