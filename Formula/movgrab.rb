class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://sites.google.com/site/columscode/home/movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fea9cd52cd0634afbd55be9028a83cd12c63f7a593874c09a30ee4c9bc08c0f2"
    sha256 cellar: :any,                 arm64_big_sur:  "9077d56a321c79670336e9555f5fb9ad6f9f2c6ba2c126e2ce0d264931a4677b"
    sha256 cellar: :any,                 monterey:       "723f43345aa8c9466522f8c0392da8d6c70979f647e69f955f8f324357da2a10"
    sha256 cellar: :any,                 big_sur:        "d2e316d743c633fd84585d13beb1beeeffd3e3fd62bf2710c2ccdaf8c59f77a6"
    sha256 cellar: :any,                 catalina:       "dec3edfeac8cd03ab450cdd0196b488401ab38d459c603b0726726b6b886a599"
    sha256 cellar: :any,                 mojave:         "c7a2f93864d81d263606610375253820937134c9f6d90cb4c5697cf21dc7c23c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be8c01fd9136b88a5b217a8581d7d7dd969eedffeb01aea19af5a8275e9e4b5c"
  end

  depends_on "libressl"

  uses_from_macos "zlib"

  # Fixes an incompatibility between Linux's getxattr and macOS's.
  # Reported upstream; half of this is already committed, and there's
  # a PR for the other half.
  # https://github.com/ColumPaget/libUseful/issues/1
  # https://github.com/ColumPaget/libUseful/pull/2
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/936597e74d22ab8cf421bcc9c3a936cdae0f0d96/movgrab/libUseful_xattr_backport.diff"
    sha256 "d77c6661386f1a6d361c32f375b05bfdb4ac42804076922a4c0748da891367c2"
  end

  # Backport fix for GCC linker library search order
  # Upstream ref: https://github.com/ColumPaget/Movgrab/commit/fab3c87bc44d6ce47f91ded430c3512ebcf7501b
  patch :DATA

  def install
    # Can you believe this? A forgotten semicolon! Probably got missed because it's
    # behind a conditional #ifdef.
    # Fixed upstream: https://github.com/ColumPaget/libUseful/commit/6c71f8b123fd45caf747828a9685929ab63794d7
    inreplace "libUseful-2.8/FileSystem.c", "result=-1", "result=-1;"

    # Later versions of libUseful handle the fact that setresuid is Linux-only, but
    # this one does not. https://github.com/ColumPaget/Movgrab/blob/HEAD/libUseful/Process.c#L95-L99
    inreplace "libUseful-2.8/Process.c", "setresuid(uid,uid,uid)", "setreuid(uid,uid)"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-ssl"
    system "make"

    # because case-insensitivity is sadly a thing and while the movgrab
    # Makefile itself doesn't declare INSTALL as a phony target, we
    # just remove the INSTALL instructions file so we can actually
    # just make install
    rm "INSTALL"
    system "make", "install"
  end

  test do
    system "#{bin}/movgrab", "--version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 04ea67d..5516051 100755
--- a/Makefile.in
+++ b/Makefile.in
@@ -11,7 +11,7 @@ OBJ=common.o settings.o containerfiles.o outputfiles.o servicetypes.o extract_te

 all: $(OBJ)
 	@cd libUseful-2.8; $(MAKE)
-	$(CC) $(FLAGS) -o movgrab main.c $(LIBS) $(OBJ) libUseful-2.8/libUseful-2.8.a
+	$(CC) $(FLAGS) -o movgrab main.c $(OBJ) libUseful-2.8/libUseful-2.8.a $(LIBS)

 clean:
 	@rm -f movgrab *.o libUseful-2.8/*.o libUseful-2.8/*.a libUseful-2.8/*.so config.log config.status
