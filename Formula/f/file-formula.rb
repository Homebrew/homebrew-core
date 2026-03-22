# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.47.tar.gz"
  sha256 "45672fec165cb4cc1358a2d76b5d57d22876dcb97ab169427ac385cbe1d5597a"
  license "BSD-2-Clause-Darwin"
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8206bf8c3019a0241b7edefd65ac74ebdc2c1f4ac0aa778a3d09e130b22484b6"
    sha256 cellar: :any,                 arm64_sequoia: "a08faff1e442c329c8b655cceffe8a00052d9d2de8221fdb64094eb7c1082295"
    sha256 cellar: :any,                 arm64_sonoma:  "2b7186fe8745be41ea7b6ea92050445039be53158bcea6dc36918fe2dd1d8db6"
    sha256 cellar: :any,                 sonoma:        "3d0694bb8026df521f1cd758ed06fd1d42c433ca86d2cf0280fd83e0aa207085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e645a47df06173285da28cd793697c479b32ff69f34e6e264da7f9f6f111081a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da75088d7e5b350e6a0a84db487e30aeaa9605ac0541ad5923e0f257213b0f33"
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
