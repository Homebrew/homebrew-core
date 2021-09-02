class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.21.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.21.tar.gz"
  sha256 "b0b7dbdefd798de7ddccdd8edf6693a30494f7789777838042991ef107339cc2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5c3247c107bc2975dec7baecff33bde0b40d50800da0d44eae17b07d4712a27c"
    sha256 cellar: :any, big_sur:       "ea88ce09e934407b1c7dfcc1b74e2d4f1b409f8264b4475b816369a129c6cd25"
    sha256 cellar: :any, catalina:      "2c62d9ef89fc346310fe219ce55c37f8673cd95672f21c5c7af6d991a52dc7fb"
    sha256 cellar: :any, mojave:        "e31aaf7e8d02d811883dba4fd804954f226d8f112974293c6d6b7a8b66648554"
    sha256               x86_64_linux:  "0cef41f29293302f68aac94fab6d6363217de9c867aad59d41c42e3cab73589a"
  end

  # Fix build failure on macOS. Merged upstream as
  # https://git.gnu.org.ua/gdbm.git/commit/?id=32517af75ac8c32b3ff4870e14ff28418696c554
  #
  # Patch taken from:
  # https://puszcza.gnu.org.ua/bugs/?521
  patch :p0, :DATA

  # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
  #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end

__END__
--- src/gdbmshell.c.orig
+++ src/gdbmshell.c
@@ -1010,7 +1010,13 @@ print_snapshot (char const *snapname, FILE *fp)
       fprintf (fp, "%s: ", snapname);
       fprintf (fp, "%03o %s ", st.st_mode & 0777,
 	       decode_mode (st.st_mode, buf));
-      fprintf (fp, "%ld.%09ld", st.st_mtim.tv_sec, st.st_mtim.tv_nsec);
+      struct timespec mtimespec;
+#ifdef __APPLE__
+      mtimespec = st.st_mtimespec;
+#else
+      mtimespec = st.st_mtim;
+#endif
+      fprintf (fp, "%ld.%09ld", mtimespec.tv_sec, mtimespec.tv_nsec);
       if (S_ISREG (st.st_mode))
 	{
 	  GDBM_FILE dbf;
