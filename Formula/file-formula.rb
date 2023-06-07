# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.44.tar.gz"
  sha256 "3751c7fba8dbc831cb8d7cc8aff21035459b8ce5155ef8b0880a27d028475f3b"
  # file-formula has a BSD-2-Clause-like license
  license :cannot_represent
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0bacf7fc3496f0522a26087a42d0bfd3f190b248b7cd42f490723b65df15a4b"
    sha256 cellar: :any,                 arm64_monterey: "fa40f52045db7b1c89b8a1853c03edfd35af995d880d167301e93203c473c0a1"
    sha256 cellar: :any,                 arm64_big_sur:  "c821076e5ea013a8356a594de19743600dc14ecbc701be392af8f404885f39e0"
    sha256 cellar: :any,                 ventura:        "9994529f7a658129dec00bfa95f133b29690881a423871c6584b7d4716992dc8"
    sha256 cellar: :any,                 monterey:       "a5b0105a244262d002c7bb25219cf4d76058c643de7eda6722cbb0bc5b7c2420"
    sha256 cellar: :any,                 big_sur:        "1457e4b2031ef8bf6aa3f26df91934bf7f7985da6708765749c724b0a189c84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557b2b68cc936ee2f9cbe2fca7bcd80535b837c7c7538b464ee8672a05f08b18"
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
index 155034b..0cc9f4d 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -151,7 +151,6 @@ libmagic_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
 	$(libmagic_la_LDFLAGS) $(LDFLAGS) -o $@
 am_file_OBJECTS = file.$(OBJEXT) seccomp.$(OBJEXT)
 file_OBJECTS = $(am_file_OBJECTS)
-file_DEPENDENCIES = libmagic.la
 AM_V_P = $(am__v_P_@AM_V@)
 am__v_P_ = $(am__v_P_@AM_DEFAULT_V@)
 am__v_P_0 = false
@@ -372,7 +371,7 @@ libmagic_la_LDFLAGS = -no-undefined -version-info 1:0:0
 @MINGW_TRUE@MINGWLIBS = -lgnurx -lshlwapi
 libmagic_la_LIBADD = -lm $(LTLIBOBJS) $(MINGWLIBS)
 file_SOURCES = file.c seccomp.c
-file_LDADD = libmagic.la -lm
+file_LDADD = $(LDADD) -lm
 CLEANFILES = magic.h
 EXTRA_DIST = magic.h.in cdf.mk BNF memtest.c
 HDR = $(top_srcdir)/src/magic.h.in
