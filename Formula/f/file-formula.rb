# "File" is a reserved class name
class FileFormula < Formula
  desc "Utility to determine file types"
  homepage "https://darwinsys.com/file/"
  url "https://astron.com/pub/file/file-5.45.tar.gz"
  sha256 "fc97f51029bb0e2c9f4e3bffefdaf678f0e039ee872b9de5c002a6d09c784d82"
  license "BSD-2-Clause-Darwin"
  head "https://github.com/file/file.git", branch: "master"

  livecheck do
    url "https://astron.com/pub/file/"
    regex(/href=.*?file[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "251cec26310d3a9487bebee946957caf8adfb2b8d9f4c2dc4f950de05e2384fd"
    sha256 cellar: :any,                 arm64_sonoma:   "46c92c7eeddf54855344d6ca8930eaa1b4119acf988ce42455fdccd20eccb439"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe86a1022a44ac24fbd0f8b40a2ee4624335cdc6f1a865f5c5ca8df5fa07b454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdaf9f9b25fcf7ea6c7bdbe44ec3f3cc0d56be0dcec1bbb9c6d4a0fd8d639e9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4058375a321cd37c7d6090f446a2da2781e199b58a9b33cf8c4af480d4381836"
    sha256 cellar: :any,                 sonoma:         "ea555131b8cf53945def5e4686babb38d502b0c907ff5e5eb4402a98e0960bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "e801499f30fee64e03dc573b510c5ddfc9eafd1e258d54e3d2b0c16fc1fb74fa"
    sha256 cellar: :any_skip_relocation, monterey:       "83c75fa244fa2a9d65f2401516a4084805abf69896ff1ba76b1c50e516fd1f82"
    sha256 cellar: :any_skip_relocation, big_sur:        "43280d24f741d9e770a41434fb8877d8004ad610fcec70b63cbc93be8d599efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52bffb8f6675e1f95f197f1247b569ad5203fde6bbdc69fdddaaf7805de520c6"
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
