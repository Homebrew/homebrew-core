class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "http://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"

  depends_on :osxfuse
  depends_on "e2fsprogs"

  def install
    ENV.append "LIBS", "-losxfuse"
    ENV.append "CFLAGS", "-D__FreeBSD__=10 -DENABLE_SWAPFS -I/usr/local/include/osxfuse/fuse -I#{HOMEBREW_PREFIX}/opt/osxfuse/include/osxfuse/fuse"
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
