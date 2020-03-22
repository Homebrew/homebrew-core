class Ext2fuse < Formula
  desc "Compact implementation of ext2 file system using FUSE"
  homepage "https://sourceforge.net/projects/ext2fuse"
  url "https://downloads.sourceforge.net/project/ext2fuse/ext2fuse/0.8.1/ext2fuse-src-0.8.1.tar.gz"
  sha256 "431035797b2783216ec74b6aad5c721b4bffb75d2174967266ee49f0a3466cd9"
  revision 1

  bottle do
    cellar :any
    sha256 "91a5c2561402f51502aa651b44426cd9fd2e8b22962a1d27d8e514ab1828fdb8" => :catalina
    sha256 "3eb552c79cbee064d7227b55b390beede8469c5c2f18491e031d7f0306f0c2cf" => :mojave
    sha256 "754488298c713b74d28b91a67b2adb082c290344d1490319e485f420cb402a02" => :high_sierra
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
