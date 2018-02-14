# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://www.darwinsys.com/file/"
  url "ftp://ftp.astron.com/pub/file/file-5.32.tar.gz"
  mirror "https://fossies.org/linux/misc/file-5.32.tar.gz"
  sha256 "8639dc4d1b21e232285cd483604afc4a6ee810710e00e579dbe9591681722b50"
  head "https://github.com/file/file.git"

  bottle do
    cellar :any
    sha256 "663cf8864eb7d0c1332cdaec2b99a1117739fca4a28f11b63416eb152162327f" => :high_sierra
    sha256 "97c729a73319a8121272b2b350acd1272dac4c056a33837b4e18fed35ee66378" => :sierra
    sha256 "915f60a63b3cd5881a385f177becdb1f2c89f8c875a3361f7dd4c55db6fb4305" => :el_capitan
    sha256 "aeee887f5d75f5d1d452adf2d9024bbc354bd28c5c20e4da0f8d6d7bb5f6f2f0" => :yosemite
  end

  keg_only :provided_by_macos

  depends_on "libmagic"

  patch :DATA

  def install
    ENV.prepend "LDFLAGS", "-L#{Formula["libmagic"].opt_lib} -lmagic"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install-exec"
    system "make", "-C", "doc", "install-man1"
    rm_r lib
  end

  test do
    system "#{bin}/file", test_fixtures("test.mp3")
  end
end

__END__
diff --git a/src/Makefile.in b/src/Makefile.in
index b6eeb20..4a7ae91 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -150,7 +150,6 @@ libmagic_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
 PROGRAMS = $(bin_PROGRAMS)
 am_file_OBJECTS = file.$(OBJEXT)
 file_OBJECTS = $(am_file_OBJECTS)
-file_DEPENDENCIES = libmagic.la
 AM_V_P = $(am__v_P_@AM_V@)
 am__v_P_ = $(am__v_P_@AM_DEFAULT_V@)
 am__v_P_0 = false
@@ -352,7 +351,7 @@ libmagic_la_LDFLAGS = -no-undefined -version-info 1:0:0
 @MINGW_TRUE@MINGWLIBS = -lgnurx -lshlwapi
 libmagic_la_LIBADD = $(LTLIBOBJS) $(MINGWLIBS)
 file_SOURCES = file.c
-file_LDADD = libmagic.la
+file_LDADD = $(LDADD)
 CLEANFILES = magic.h
 EXTRA_DIST = magic.h.in
 HDR = $(top_srcdir)/src/magic.h.in
