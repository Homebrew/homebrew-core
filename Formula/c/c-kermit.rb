class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.kermitproject.org/"
  url "https://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"
  license "BSD-3-Clause"

  # C-Kermit archive file names only contain the patch version and the full
  # version has to be obtained from text on the project page.
  livecheck do
    url "https://www.kermitproject.org/ckermit.html"
    regex(/The current C-Kermit release is v?(\d+(?:\.\d+)+) /i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c0e72e5bb4d72caed49b3f6d972c288574cf259071e49b9f2d7cecb996dbce8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc6dba17341e3f98196d564a5fffc6302338e58371b4eca3ebeedb82e274606e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab2fa4f2c5baad32ef5a049ac5a386f2b8900e2a0083cd666476b66287a03e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "39dea4932cd8e64dc2f836f6614bf7e1a27547f5256c18bd96b6a52ffcc42147"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e5b61305d55c1c90bb0a83b2a3d60684e5e8e9104b6dbc8c84637132114054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "694f5ef3996f1e14a0ef1c1117902226f1eaba0488a27dbc248a52af354121b1"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  # Apply patch to fix build failure with glibc 2.28+
  # Apply patch to fix build failure on Sonoma (missing headers)
  # Will be fixed in next release: https://www.kermitproject.org/ckupdates.html
  # Apply patch to fix memory corruption on macos where -DNOUUCP is used where an unintended codepath was taken.
  # Patch for this soruced from beta 10.0:
  # Notes on the bugfixes can be found in C-Kermit 10.0 NOTES.TXT lines 2533-2538 and 3356-3370
  # Or in the code:
  # ckucmd.c#L1694-L1696
  # ckufio.c#L2746-L2748
  # ckufio.c#L2827

  patch :DATA

  def install
    # Makefile only supports system libraries on Linux
    if OS.linux?
      inreplace "makefile" do |s|
        s.gsub! "/usr/include/ncurses", "#{Formula["ncurses"].opt_include}/ncurses"
        s.gsub! "/usr/lib/libncurses", "#{Formula["ncurses"].opt_lib}/libncurses"
        s.gsub! "/usr/include/crypt", "#{Formula["libxcrypt"].opt_include}/crypt"
        s.gsub! "/usr/lib/libcrypt", "#{Formula["libxcrypt"].opt_lib}/libcrypt"
      end
    end

    os = OS.mac? ? "macosx" : "linux"
    system "make", os
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_match "C-Kermit #{version}",
                 shell_output("#{bin}/kermit -C VERSION,exit")
  end
end

__END__
diff -ru z/ckucmd.c k/ckucmd.c
--- z/ckucmd.c	2004-01-07 10:04:04.000000000 -0800
+++ k/ckucmd.c	2019-01-01 15:52:44.798864262 -0800
@@ -7103,7 +7103,7 @@
 
 /* Here we must look inside the stdin buffer - highly platform dependent */
 
-#ifdef _IO_file_flags			/* Linux */
+#ifdef _IO_EOF_SEEN			/* Linux */
     x = (int) ((stdin->_IO_read_end) - (stdin->_IO_read_ptr));
     debug(F101,"cmdconchk _IO_file_flags","",x);
 #else  /* _IO_file_flags */
diff --git a/ckcdeb.h b/ckcdeb.h
index 34ff008..a066187 100644
--- a/ckcdeb.h
+++ b/ckcdeb.h
@@ -2374,6 +2374,62 @@ _PROTOTYP( void bleep, (short) );
 #ifndef NETCMD
 #define NETCMD
 #endif /* NETCMD */
+
+#ifndef NO_OPENPTY			/* Can use openpty() */
+#ifndef HAVE_OPENPTY
+#ifdef __linux__
+#define HAVE_OPENPTY
+#else
+#ifdef __FreeBSD__
+#define HAVE_OPENPTY
+#else
+#ifdef __OpenBSD__
+#define HAVE_OPENPTY
+#else
+#ifdef __NetBSD__
+#define HAVE_OPENPTY
+#include <util.h>
+#else
+#ifdef MACOSX10
+#define HAVE_OPENPTY
+#endif	/* MACOSX10 */
+#endif	/* __NetBSD__ */
+#endif	/* __OpenBSD__ */
+#endif	/* __FreeBSD__ */
+#endif	/* __linux__ */
+#endif	/* HAVE_OPENPTY */
+#endif	/* NO_OPENPTY */
+/*
+  This needs to be expanded and checked.
+  The makefile assumes the library (at least for all linuxes)
+  is always libutil but I've only verified it for a few.
+  If a build fails because
+*/
+#ifdef HAVE_OPENPTY
+#ifdef __linux__
+#include <pty.h>
+#else
+#ifdef __NetBSD__
+#include <util.h>
+#else
+#ifdef __OpenBSD__
+#include <util.h>
+#else
+#ifdef __FreeBSD__
+#include <libutil.h>
+#else
+#ifdef MACOSX
+#include <util.h>
+#else
+#ifdef QNX
+#include <unix.h>
+#endif  /* QNX */
+#endif  /* MACOSX */
+#endif  /* __FreeBSD__ */
+#endif  /* __OpenBSD__ */
+#endif  /* __NetBSD__ */
+#endif  /* __linux__ */
+#endif  /* HAVE_OPENPTY */
 #endif /* NETPTY */
 
 #ifndef CK_UTSNAME			/* Can we call uname()? */
diff --git a/ckcmai.c b/ckcmai.c
index a5640e5..0257050 100644
--- a/ckcmai.c
+++ b/ckcmai.c
@@ -1590,6 +1590,12 @@ cc_clean();                             /* This can't be right? */
 #endif /* GEMDOS */
 #endif /* NOCCTRAP */
 
+#ifdef TIMEH
+/* This had to be added for NetBSD 6.1 - it might have "effects" elsewhere */
+/* Tue Sep  3 17:03:42 2013 */
+#include <time.h>
+#endif /* TIMEH */
+
 #ifndef NOXFER
 /* Info associated with a system ID */
 
diff --git a/ckuusx.c b/ckuusx.c
index d332bed..d3de9ae 100644
--- a/ckuusx.c
+++ b/ckuusx.c
@@ -43,6 +43,10 @@
 #define NOHTERMCAP
 #else
 #ifdef MACOSX
+#ifndef OLDMACOSX           
+#include <term.h>           /* macOS after 10.12 */
+#include <curses.h>
+#endif /* OLDMACOSX */
 #define NOHTERMCAP
 #endif /* MACOSX */
 #endif /* OPENBSD */
diff --git a/ckwart.c b/ckwart.c
index 2f3bb75..71b9080 100644
--- a/ckwart.c
+++ b/ckwart.c
@@ -493,7 +493,8 @@ warray(fp,nam,cont,siz,typ) FILE *fp; char *nam; int cont[],siz; char *typ; {
     fprintf(fp,"%2d\n};\n",cont[siz-1]);
 }
 
-#ifndef STRATUS
+int
+#if 0
 #ifdef MAINTYPE
 /*
   If you get complaints about "main: return type is not blah",
diff --git a/ckucmd.c b/ckucmd.c
index 274dc2d..5364bfd 100644
--- a/ckucmd.c
+++ b/ckucmd.c
@@ -1577,7 +1577,7 @@ o_again:
     }
 #endif /* CK_TMPDIR */
 
-    if (strcmp(s,CTTNAM) && (zchko(s) < 0)) { /* OK to write to console */
+    if ((strcmp(s,CTTNAM) == 0) && (zchko(s) < 0)) { /* write to console OK */
 #ifdef COMMENT
 #ifdef OS2
 /*
diff --git a/ckufio.c b/ckufio.c
index b5bfaae..b1fb374 100644
--- a/ckufio.c
+++ b/ckufio.c
@@ -2596,6 +2596,7 @@ zchko(name) char *name; {
 	} else {
 	    debug(F101,"zchko open errno","",errno); 
 	    x = -1;
+        goto xzchko;
 	}
     }
 #endif	/* NOUUCP */
@@ -2667,6 +2668,7 @@ zchko(name) char *name; {
     debug(F100,"zchko swapped ids restored","",0);
 #endif /* SW_ACC_ID */
 
+xzchko:                               /* Exit point */
     if (x < 0)
       debug(F111,"zchko access failed:",s,errno);
     else
