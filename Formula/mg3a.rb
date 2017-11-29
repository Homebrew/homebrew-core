class Mg3a < Formula
  desc "Small Emacs-like editor inspired by mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.170403.tar.gz"
  sha256 "43a4898ce319f119fad583899d0c13a50ee6eb8115062fc388dad028eaddd2cc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b21356ba4ce19ab0a37e23de2ab700df0ddf5929422fe5bc1b4dc69e4ae0050" => :high_sierra
    sha256 "fa6df4b7b8598b0a81499fb3ebfeb09233bdeac2c7150292dd6acaa9ecb787bc" => :sierra
    sha256 "4330835634faef0f93eb7340d1b6ad992669422d93210b209df28007f80658f6" => :el_capitan
    sha256 "4017a82bff19eb00a699206494bcaa456dbe70a529edd75fd80044064de26965" => :yosemite
  end

  option "with-all",  "Include all fancy stuff"

  conflicts_with "mg", :because => "both install `mg`"

  patch :p1, :DATA

  def install
    if build.with?("all")
      mg3aopts = %w[-DALL]
    else
      mg3aopts = %w[-DDIRED -DPREFIXREGION -DSEARCHALL -DPIPEIN -DUSER_MODES -DUSER_MACROS -DLANGMODE_PYTHON -DLANGMODE_CLIKE]
    end

    system "make", "CDEFS=#{mg3aopts * " "}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    (testpath/"command.sh").chmod 0755

    system testpath/"command.sh"
  end
end

__END__
--- a/README.misc
+++ b/README.misc
@@ -1,5 +1,14 @@
 Startup files:
 
+Starting from 170703, Mg can be placed at the end of a pipe.
+It will then read the pipe and display the output in
+a READ ONLY buffer named *stdin*:
+
+ls | mg
+
+Time consuming commands will make mg to show the *scratch* buffer until
+the pipe is fully read.
+
 For compatibility, Mg reads two startup files if they exist, .mg-$TERM
 and .mg, in that order. Startup execution is below.
 
@@ -35,6 +44,7 @@
   endif
   load "-L" script
   visit file(s)
+  read stdin to *stdin* buffer if mg at end of pipe
   goto "+" line
   load "-l" script
   execute "-e" commands.
--- a/def.h
+++ b/def.h
@@ -12,6 +12,7 @@
 #define UCSNAMES
 #define USER_MODES
 #define USER_MACROS
+#define WITH_PIPEIN
 #endif
 
 /* Obligatory definitions */
@@ -671,6 +672,7 @@
 BUFFER	*findbuffer(char *fname);
 void	setcharsetfromcontent(BUFFER *bp);
 INT	readin(char *fname);
+INT	freadin(FILE *f);
 INT	buffsave(BUFFER *bp);
 void	upmodes(BUFFER *bp);
 void	refreshbuf(BUFFER *bp);
@@ -679,6 +681,7 @@
 
 /* fileio.c */
 
+INT	ffrset(FILE *f);
 INT	ffropen(char *fn);
 INT	ffwopen(char *fn);
 INT	ffclose(void);
--- a/file.c
+++ b/file.c
@@ -5,6 +5,8 @@
 #include	"def.h"
 
 static INT	insertfile(char *fname, char *newname);
+static INT	finsertfile(FILE *f);
+static INT	doinsertfile(char *newname);
 static void	makename(char *bname, char *fname, INT buflen);
 static INT	writeout(BUFFER *bp, char *fn);
 
@@ -424,6 +426,61 @@
 	return status;
 }
 
+/*
+ * Read the file "fname" into the current buffer. Make all of the text
+ * in the buffer go away, after checking for unsaved changes. This is
+ * called by the "read" command, the "visit" command, and the mainline
+ * (for "mg file").
+ */
+
+INT
+freadin(FILE *f)
+{
+	INT		status;
+	WINDOW		*wp;
+
+	if (bclear(curbp) != TRUE)		/* Might be old.	*/
+		return TRUE;
+
+	count_crlf = 0;
+	count_lf = 0;
+
+	status = finsertfile(f) ;
+
+	if (count_lf > count_crlf) {
+		internal_unixlf(1);		/* Set Unix line endings */
+	} else if (count_crlf > count_lf) {
+		internal_unixlf(0);		/* Set MS-DOS line endings */
+	}
+
+	if (!termcharset) {
+		internal_utf8(0);
+		internal_bom(0);
+	} else if (find_and_remove_bom(curbp)) {
+		internal_utf8(1);
+		internal_bom(1);
+	} else {
+		setcharsetfromcontent(curbp);
+	}
+
+	setmodefromfileextension(1);
+	curbp->b_flag &= ~BFCHG;		/* No change.		*/
+
+	// Reset all windows to beginning
+
+	for (wp = wheadp; wp; wp = wp->w_wndp) {
+		if (wp->w_bufp == curbp) {
+			wp->w_dotp   = wp->w_linep = lforw(curbp->b_linep);
+			wp->w_doto   = 0;
+			wp->w_markp  = NULL;
+			wp->w_marko  = 0;
+			wp->w_dotpos = 0;
+		}
+	}
+
+	return status;
+}
+
 
 /*
  * Insert a file in the current buffer, after dot. Set mark at the end
@@ -442,14 +499,7 @@
 static INT
 insertfile(char *fname, char *newname)
 {
-	INT		nbytes, maxbytes = 2*NLINE;
 	INT		s;
-	size_t 		nline;
-	LINE		*prevline;
-	INT		savedoffset;
-	size_t		savedpos;
-	int		first = 1;
-	char		*cp, *cp2;
 
 	if (curbp->b_flag & BFREADONLY) return readonly();
 
@@ -473,6 +523,24 @@
 			return FALSE;
 		}
 	}
+	return doinsertfile(newname);
+}
+
+static INT	finsertfile(FILE *f)
+{
+	ffrset(f);
+	return doinsertfile(NULL);
+}
+
+static INT doinsertfile(char *newname)
+{
+	INT		s, nbytes, maxbytes = 2*NLINE;
+	size_t 		nline;
+	LINE		*prevline;
+	INT		savedoffset;
+	size_t	savedpos;
+	int		first = 1;
+	char	*cp, *cp2;
 
 	prevline = lback(curwp->w_dotp);
 	savedoffset = curwp->w_doto;
--- a/fileio.c
+++ b/fileio.c
@@ -50,6 +50,14 @@
 }
 
 
+INT ffrset(FILE *f) {
+	if ((ffp = f) == NULL)
+		return FIOFNF;
+	io_buflen = 0;
+	io_bufptr = 0;
+	return FIOSUC;
+}
+
 /*
  * Open a file for reading.
  */
@@ -57,13 +65,7 @@
 INT
 ffropen(char *fn)
 {
-	if ((ffp=fopen(fn, "r")) == NULL) {
-		return FIOFNF;
-	}
-
-	io_buflen = 0;
-	io_bufptr = 0;
-	return FIOSUC;
+	return ffrset(fopen(fn, "r"));
 }
 
 
--- a/main.c
+++ b/main.c
@@ -42,12 +42,25 @@
 	char	*linearg = NULL;
 	INT	lineno;
 	char	*loadfile = NULL, *startexpr = NULL, *pre_loadfile = NULL;
+#ifdef PIPEIN
+	FILE *pipein = NULL;
 
+ 	if (!isatty(fileno(stdin))) {
+ 		/*
+		 * Create a copy of stdin for future use
+ 		 */
+		pipein = fdopen(dup(fileno(stdin)),"r");
+ 		/*
+ 		 * Reopen the console device /dev/tty as stdin
+ 		 */
+ 		stdin = freopen("/dev/tty","r",stdin);
+	}
+#else
 	if (!isatty(0)) {
 		fprintf(stderr, "mg: standard input is not a tty\n");
 		exit(1);
 	}
-
+#endif
 	setlocale(LC_ALL, "");
 
 	while ((c = getopt(argc, argv, "qp:L:l:e:")) != -1) {
@@ -124,7 +137,16 @@
 
 		if (readin(cp) != TRUE) break;
 	}
-
+#ifdef PIPEIN
+	if (NULL != pipein) {
+		if ((bp = findbuffer("*stdin*")) != NULL) {
+			curbp = bp;
+			showbuffer(curbp, curwp);
+			freadin(pipein);
+			curbp->b_flag |= BFREADONLY;
+		}
+	}
+#endif
 	if (linearg) {
 		if (linearg[1] == 0) gotoline(FFARG, 0);
 		else if (getINT(linearg + 1, &lineno, 1)) gotoline(FFARG, lineno);
--- a/Makefile
+++ b/Makefile
@@ -1,11 +1,17 @@
 # Makefile for Mg 3a
 
-CC=gcc -pipe
-COPT=-O2
+# These are defaults, change them in your external build tool
+# * in Linux, you can use pkg-config to customize ncurses libs and includes
+# * in Cygwin, set CC=gcc
+# * in xBSD or Darwin, set CC=clang
+
+CC=cc
+COPT=-O3
+LIBS=-lcurses
+# Try if -lncurses doesn't work
 
-#LIBS		= -lncurses	# Try if -lcurses doesn't work
-LIBS		= -lcurses
-PREFIX 		?= /usr/local	# For install entries
+# For install entries
+PREFIX ?= /usr/local
 
 
 # Current supported compile-time options:
@@ -13,6 +19,7 @@
 #	NO_TERMH	-- If you don't have <term.h> (or on Cygwin <ncurses/term.h>) you
 #			   can use this. You then don't get keypad keys defined.
 #	DIRED		-- enable "dired".
+#	PIPEIN		-- enable reading from pipe at startup
 #	PREFIXREGION	-- enable function "prefix-region"
 #	CHARSDEBUG	-- A debugging tool for input/output
 #	SLOW		-- Implement "slow-mode" command for emulating a slow terminal
@@ -33,7 +40,13 @@
 #CDEFS	= -DBSMAP=1 -DMAKEBACKUP=1
 
 # Everything GNU Emacs and mg2a-like by default
-CDEFS = -DDIRED -DPREFIXREGION
+# CDEFS = -DDIRED -DPREFIXREGION
+
+# Advanced mg3a with python and clike mode,
+# no c-mode, nor UCS_NAMES, nor simple search
+CDEFS = -DDIRED -DPREFIXREGION -DSEARCHALL \
+    -DLANGMODE_PYTHON -DLANGMODE_CLIKE \
+    -DUSER_MODES -DUSER_MACROS
 
 # Everything.
 #CDEFS	= -DALL
@@ -66,7 +79,7 @@
 OINCS =	ttydef.h sysdef.h chrdef.h cpextern.h
 INCS =	def.h
 
-doit: mg
+all: mg
 
 test: COPT += -Wall -Wextra -Wno-unused-parameter
 
--- a/version.c
+++ b/version.c
@@ -5,7 +5,7 @@
 
 #include	"def.h"
 
-char version[] = "Mg3a, version 170403";
+char version[] = "Mg3a, version 171122";
 
 
 /*
