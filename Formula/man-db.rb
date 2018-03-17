class ManDb < Formula
  desc "Implementation of the standard Unix man page system, often used on Linux"
  homepage "https://nongnu.org/man-db/"
  url "https://download.savannah.nongnu.org/releases/man-db/man-db-2.8.2.tar.xz"
  sha256 "45bdff87df888ddd93dc2a68abca91a2012d6e08333a8fc7c0dfefe9cbde0c5c"

  depends_on "libpipeline"

  # First patch explanation:
  # The first two patches are actually the same patch for two different files.
  # Since this utility is intended for Linux systems, it expects to chown the
  # installed files as man:man. But, since we're on OS X, this username/group
  # doesn't exist. Obviously, we don't want to create ad-hoc usernames or groups
  # just to install this one program.
  #
  # Second patch explanation:
  # Gnulib, part of man-db and libpipeline, externs a symbol called
  # `program_name`. This symbol is supposed to be defined by glibc, which is to
  # be expected on Linux. However, since we're on OS X, we don't have glibc and
  # so this symbol will not be defined. This is a known issue and several work-
  # arounds have been proposed by different people. One option is to use some
  # CFLAGS to suppress errors about undefined symbols. Unfortunately, this only
  # seems to work for man-db and doesn't work for other programs which link with
  # libpipeline. This patch is a more general solution. Unfortunately, the
  # upstream has not accpted this patch for two years and so they probably never
  # will. For more info, visit these links:
  # https://stackoverflow.com/questions/36824434/libpipeline-fails-to-compile-on-mac-os-x
  # https://github.com/NixOS/nixpkgs/issues/15849
  # https://lists.gnu.org/archive/html/bug-gnulib/2015-02/msg00079.html
  patch :DATA

  def install
    ENV["CC"] = "#{ENV.cc} -arch x86_64"

    system "./configure", "--prefix=#{prefix}", "--with-systemdtmpfilesdir=''"
    system "make", "CFLAGS=\"-Wl,-flat_namespace,-undefined,suppress\""
    system "make", "install"
  end

  test do
    ENV["PAGER"] = "cat"
    true_man_page = <<~EOS
      TRUE(1)                                      BSD General Commands Manual                                     TRUE(1)

      NAME
           true -- Return true value.

      SYNOPSIS
           true

      DESCRIPTION
           The true utility always returns with exit code zero.

      SEE ALSO
           csh(1), sh(1), false(1)

      STANDARDS
           The true utility conforms to IEEE Std 1003.2-1992 (``POSIX.2'').

      BSD                                                 June 27, 1991                                                BSD
EOS
    output = shell_output("#{bin}/man true")
    assert_match(true_man_page, output)
  end
end

__END__
diff --git a/src/Makefile.am b/src/Makefile.am
index dd7232e6..cc5c9a0d 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -173,11 +173,6 @@ apropos$(EXEEXT): whatis$(EXEEXT)
 all-am: apropos$(EXEEXT)

 install-exec-hook:
-	if [ "$(man_owner)" ] && [ "$(man_mode)" = 6755 ]; then \
-		chown $(man_owner):$(man_owner) \
-			$(DESTDIR)$(bindir)/$(TRANS_MAN) \
-			$(DESTDIR)$(bindir)/$(TRANS_MANDB); \
-	fi
 	chmod $(man_mode) \
 		$(DESTDIR)$(bindir)/$(TRANS_MAN) \
 		$(DESTDIR)$(bindir)/$(TRANS_MANDB)
diff --git a/src/Makefile.in b/src/Makefile.in
index 5ab90d47..4261d6c8 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -2214,11 +2214,6 @@ apropos$(EXEEXT): whatis$(EXEEXT)
 all-am: apropos$(EXEEXT)

 install-exec-hook:
-	if [ "$(man_owner)" ] && [ "$(man_mode)" = 6755 ]; then \
-		chown $(man_owner):$(man_owner) \
-			$(DESTDIR)$(bindir)/$(TRANS_MAN) \
-			$(DESTDIR)$(bindir)/$(TRANS_MANDB); \
-	fi
 	chmod $(man_mode) \
 		$(DESTDIR)$(bindir)/$(TRANS_MAN) \
 		$(DESTDIR)$(bindir)/$(TRANS_MANDB)
diff --git a/gnulib/lib/error.c b/gnulib/lib/error.c
index 31109df3..6b68cd15 100644
--- a/gnulib/lib/error.c
+++ b/gnulib/lib/error.c
@@ -110,9 +110,13 @@ int strerror_r ();
 #  endif
 # endif

+#if defined __APPLE__ && defined __MACH__
+#define program_name (((char **)*_NSGetArgv())[0])
+#else
 /* The calling program should define program_name and set it to the
    name of the executing program.  */
 extern char *program_name;
+#endif

 # if HAVE_STRERROR_R || defined strerror_r
 #  define __strerror_r strerror_r
