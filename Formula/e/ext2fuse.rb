class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse/"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  license "GPL-2.0-or-later"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fe9d3ea0a65c95de091aecb536ee498015bdc07b7c12e4367617cf9e78c76941"
  end

  # Last release on 2008-06-26. Needs `libfuse@2` and patches to build
  deprecate! date: "2025-03-06", because: :unmaintained

  depends_on arch: :x86_64
  depends_on "e2fsprogs"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  # Fix build failure because of missing argument to open() Linux.
  # Patch submitted upstream to SourceForge page:
  # https://sourceforge.net/p/ext2fuse/patches/2/
  patch :DATA

  def install
    ENV.append "CFLAGS", "-D__i386__"
    ENV.append "CFLAGS", "-DHAVE_TYPE_SSIZE_T"
    ENV.append "CFLAGS", "-DNO_INLINE_FUNCS"
    ENV.append "CFLAGS", "-I#{Formula["libfuse@2"].opt_include}/fuse"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/lib/ext2fs/ismounted.c b/lib/ext2fs/ismounted.c
index 1b9cd36..a7d8235 100644
--- a/lib/ext2fs/ismounted.c
+++ b/lib/ext2fs/ismounted.c
@@ -150,7 +150,7 @@ static errcode_t check_mntent_file(const char *mtab_file, const char *file,
 is_root:
 #define TEST_FILE "/.ismount-test-file"		
 		*mount_flags |= EXT2_MF_ISROOT;
-		fd = open(TEST_FILE, O_RDWR|O_CREAT);
+		fd = open(TEST_FILE, O_RDWR|O_CREAT, S_IRUSR|S_IRGRP);
 		if (fd < 0) {
 			if (errno == EROFS)
 				*mount_flags |= EXT2_MF_READONLY;
