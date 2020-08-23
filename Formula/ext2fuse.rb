class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  revision 2

  bottle do
    cellar :any
    sha256 "41c770edbb267f3d8d1fe591d947148e7c190adec47940f7d0d6dd1516b6592c" => :catalina
    sha256 "541b0787069c0bf37607392a9789ed4e3b2f21ebe214b3274ec27023aa03335f" => :mojave
    sha256 "0b8e89292e91a8fbe00430ae16a3ebbfdbba1017f6dee4801bcf8e63d238962f" => :high_sierra
  end

  depends_on "e2fsprogs"
  depends_on :osxfuse

  def install
    ENV.append "LIBS", "-losxfuse"
    ENV.append "CFLAGS",
      "-D__FreeBSD__=10 -DENABLE_SWAPFS -I/usr/local/include/osxfuse/fuse " \
      "-I#{HOMEBREW_PREFIX}/opt/osxfuse/include/osxfuse/fuse"
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
