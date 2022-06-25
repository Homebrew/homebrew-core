class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  revision 2

  bottle do
    sha256 cellar: :any, catalina:    "41c770edbb267f3d8d1fe591d947148e7c190adec47940f7d0d6dd1516b6592c"
    sha256 cellar: :any, mojave:      "541b0787069c0bf37607392a9789ed4e3b2f21ebe214b3274ec27023aa03335f"
    sha256 cellar: :any, high_sierra: "0b8e89292e91a8fbe00430ae16a3ebbfdbba1017f6dee4801bcf8e63d238962f"
  end

  depends_on "e2fsprogs"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

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

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
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
