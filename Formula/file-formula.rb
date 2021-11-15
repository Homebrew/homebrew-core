# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.41.tar.gz"
  sha256 "13e532c7b364f7d57e23dfeea3147103150cb90593a57af86c10e4f6e411603f"
  # file-formula has a BSD-2-Clause-like license
  license :cannot_represent
  head "https://github.com/file/file.git"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "62330e525abefef9b0ee14c3c68eda5b3929885d40047ed3ff986a55530c1291"
    sha256 cellar: :any,                 arm64_big_sur:  "15e4b048fc9187617a94167c6a380334ba6b007f10c0b2e053f7eb819a07f487"
    sha256 cellar: :any,                 monterey:       "c7e02240e32e51a7864951464452210f93ab0d69b1db271620bdbca05c10664b"
    sha256 cellar: :any,                 big_sur:        "23a026b284b4a3b4d35bd2523dd2ff29e7067ba1a9398237f22187ff4b03ea99"
    sha256 cellar: :any,                 catalina:       "42b22fa1942a019e33f96f30af4e58bbffd586a14d9fba7318973b9d519aa264"
    sha256 cellar: :any,                 mojave:         "5b11f9096a34a2d37b3fdfc89836936d539b3db6da1e5468fc4d21e25d76160c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a7e755b89c571f80b085d72602f34faefdaab64f7d879c3bb876c46480e8c69"
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
