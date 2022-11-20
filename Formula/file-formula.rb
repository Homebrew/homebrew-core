# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.43.tar.gz"
  sha256 "8c8015e91ae0e8d0321d94c78239892ef9dbc70c4ade0008c0e95894abfb1991"
  # file-formula has a BSD-2-Clause-like license
  license :cannot_represent
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5af7991cbec38b44fbde8e3f698b586b9621f2da7680f5ff74d57cb6aa654d64"
    sha256 cellar: :any,                 arm64_monterey: "4670bf33cb4a2a2ec2167ba316f91d61ef524e67c0ec232ca2f513e4c6cc4a62"
    sha256 cellar: :any,                 arm64_big_sur:  "983ef3239b886fa044a56adc2797f63b4d2930d7e68f589e8cd386d4663f2fe7"
    sha256 cellar: :any,                 ventura:        "a52371b9d176c1d2504772344c3862e8ed31fe474b7ae1a553c9822532a58591"
    sha256 cellar: :any,                 monterey:       "70ff46e2a33856064bfd7ab5752a26e2479fbef2c031cbca2a3c7c0eee867c33"
    sha256 cellar: :any,                 big_sur:        "91a17666871d695c9c0df10afdb2b41835da1a8114dcba529e65f0feeffe2c8f"
    sha256 cellar: :any,                 catalina:       "95ce9f08f5efa8f6c43390ab8ddc1f1807bba036419985f529ad1678c60cd595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "156e61105587eaf3a1b7ee41b5a427cae1aa3eb873b07cf320989458957365e1"
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
