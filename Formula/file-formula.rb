# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.40.tar.gz"
  sha256 "167321f43c148a553f68a0ea7f579821ef3b11c27b8cbe158e4df897e4a5dd57"
  # file-formula has a BSD-2-Clause-like license
  license :cannot_represent
  head "https://github.com/file/file.git"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "707df034d66e4a7e448fd1849f266634d5095f0605a8c7354bf5f0cf4fc5a45f"
    sha256 cellar: :any,                 big_sur:       "90936b82c5dae98ee47784aea42bb8c085febf2bdc860c5c5d8d553d6b958201"
    sha256 cellar: :any,                 catalina:      "79a0d7c166aaccfef9c381350dae30f8547a68b99e380f8d542fc92a05d1e8cf"
    sha256 cellar: :any,                 mojave:        "7c351f1d74d78678bdff2d1ba0f245a7d3e6933e56ce726d60488e5d78cfa631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117e35f17ed4d51743b23c336286438c26158521a7e21139ddc5de565b3824d5"
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
index c096c71..583a0ba 100644
--- a/src/Makefile.in
+++ b/src/Makefile.in
@@ -115,7 +115,6 @@ libmagic_la_LINK = $(LIBTOOL) $(AM_V_lt) --tag=CC $(AM_LIBTOOLFLAGS) \
 PROGRAMS = $(bin_PROGRAMS)
 am_file_OBJECTS = file.$(OBJEXT) seccomp.$(OBJEXT)
 file_OBJECTS = $(am_file_OBJECTS)
-file_DEPENDENCIES = libmagic.la
 AM_V_P = $(am__v_P_@AM_V@)
 am__v_P_ = $(am__v_P_@AM_DEFAULT_V@)
 am__v_P_0 = false
@@ -311,7 +310,7 @@ libmagic_la_LDFLAGS = -no-undefined -version-info 1:0:0
 @MINGW_TRUE@MINGWLIBS = -lgnurx -lshlwapi
 libmagic_la_LIBADD = $(LTLIBOBJS) $(MINGWLIBS)
 file_SOURCES = file.c seccomp.c
-file_LDADD = libmagic.la
+file_LDADD = $(LDADD)
 CLEANFILES = magic.h
 EXTRA_DIST = magic.h.in
 HDR = $(top_srcdir)/src/magic.h.in
