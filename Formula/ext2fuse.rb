class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cf8a8ab7893e4703857cc93f41853567140bb2713e90dffd0db844d916d83ce9"
  end

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
