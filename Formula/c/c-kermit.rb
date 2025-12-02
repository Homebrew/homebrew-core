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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9f4e1eb3f4cea80c8e82892451358cc831f6aebcd024a7776a2ce89d86fd8c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cea3196c019d7d08ec77210cc9ce17c3339c84d5255f914bf773e5186ae709bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "399806a413435186dd70cd55cd12782354c3642259870b348f81ca40b6424cbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ee8af35826f4b5be62d1c4b4e8b38eb39915da0b28d6b8f53ff9dfbb99f6698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8315af8bc632253d0b2fdfde4b9da0fef5ad11af891b4e4eb8b51a35902f1e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "259f1f0d2e2a1af6545bec724db3e1f154169dbd33e2b8ef43364381b3664cfe"
    sha256 cellar: :any_skip_relocation, sonoma:         "b940d6c43c5b2298913376ff58726c674de4a741353460e7de2a94c7d01d99df"
    sha256 cellar: :any_skip_relocation, ventura:        "0772fae0e560c8e726c611bd1e5b55d03e77f6f42feb3f763cb12f15a0151dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "e379dd0cdd6eb9eec792cdd48ca7c5b7cd9281288840b15ce1d860fbb78982b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2867c176bc81a35f56d5fe29847500b7c5f8c3e05ac10b5986073502a888a0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7c5ef16933a585d24b5186f5588e5cbb59d3a57af93e447660e159dc98a649f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5959e91d9fce4bee2b835433a8d2cc589f8f9f37e02c0f1078dbe645e6351a"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  # Apply patch to fix build failure with glibc 2.28+
  # Apply patch to fix build failure on Sonoma (missing headers)
  # Will be fixed in next release: https://www.kermitproject.org/ckupdates.html
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
