# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.46.tar.gz"
  sha256 "c9cc77c7c560c543135edc555af609d5619dbef011997e988ce40a3d75d86088"
  license "BSD-2-Clause-Darwin"
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "65b81cd6df1455e32335632e523b2dc5a8401714d3425dcb5c6d8661043a8b03"
    sha256 cellar: :any,                 arm64_sequoia: "5fe19d9d579de777487bbaa3722d672da01bcfae88f92af992918069bb5a0ac0"
    sha256 cellar: :any,                 arm64_sonoma:  "573bef480b6d3091dac30e1c279c18285ad25df7a30eea2805abe96aadce828a"
    sha256 cellar: :any,                 arm64_ventura: "99647711bffd2202b37256b511b365f4d1896b4ff6c0434d280dcff204d7ff10"
    sha256 cellar: :any,                 sonoma:        "3fea058cdd5fc0e35dc5eac1d7c50e08bea271f93bd68bcd679c3a25073aa559"
    sha256 cellar: :any,                 ventura:       "c05544f86ae7b5a8469dede0beaa2553c083195e183cc842fd818db0cfe037e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eeccdbca7917d06791d243ff165509f95bb086d696b25add4c288c32be099e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2ca7e9679bf47ba1ddc966bef0a2c2fa1d85280122449fae5dc877fc0ba8874"
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
    system bin/"file", test_fixtures("test.mp3")
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
