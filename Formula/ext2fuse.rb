class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  revision 1

  bottle do
    cellar :any
    sha256 "183585fee33c1752f5c7ee7dbf3174e4c1af7646d3a6ebbd844437d6c50fe3e5" => :catalina
    sha256 "f3f1a63cf8c5c375e5ebd93a03c33f3bd6df148045171697fbe99a67884b929e" => :mojave
    sha256 "db5601be89a17e1d0496cf698c6a61adeb6aad617b47d2f93fe35b6176d735a2" => :high_sierra
    sha256 "22f2c626da7fbf83036debd9d3a564334c7d12919828c90cdb820c69c7911e3f" => :sierra
    sha256 "fcf23e3ef7bf5afed5f3a009c4e41e4fbe6852faac0dff0cc5c8f35b3b491571" => :el_capitan
    sha256 "01064d0a21a3a1d60686657df9146194700c879e5b43447c4a6cbc80cc62705b" => :yosemite
  end

  depends_on "e2fsprogs"
  depends_on :osxfuse

  def install
    ENV.append "LIBS", "-losxfuse"
    ENV.append "CFLAGS", "-D__FreeBSD__=10 -DENABLE_SWAPFS -I/usr/local/include/osxfuse/fuse -I#{HOMEBREW_PREFIX}/opt/osxfuse/include/osxfuse/fuse"
    ENV.append "CFLAGS", "--std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
