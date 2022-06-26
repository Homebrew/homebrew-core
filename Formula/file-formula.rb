# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.42.tar.gz"
  sha256 "c076fb4d029c74073f15c43361ef572cfb868407d347190ba834af3b1639b0e4"
  # file-formula has a BSD-2-Clause-like license
  license :cannot_represent
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "320c0c43bb0354944ffd8f877130e0677673caa6d27b644df302b5181a7586d0"
    sha256 cellar: :any,                 arm64_big_sur:  "f7511025862041ba5661df24e8dc996558911e77689eabeafb2f5c0028c69c69"
    sha256 cellar: :any,                 monterey:       "6c0720b2baa60480d2ae9764b372f57fdda6bb6bc0cacca755a79b34a8ef2a0e"
    sha256 cellar: :any,                 big_sur:        "27f93809e79cd8b4bc860498d7a92e6631c4db8944c922016874a7491ec6dfbc"
    sha256 cellar: :any,                 catalina:       "3a9e43b348aef84582721d185db2c1d259bb270dd0fdbf1b31376f97fa052c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "947e053ef04495b1c718067ff1cb08b0e339c05697d1f8964bcc89339f6c5cda"
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
