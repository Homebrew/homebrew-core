class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.13.tar.gz"
  sha256 "494c3e16261e3c7535efa86493e09270dde29cd7121e97c29d226c239cbeabd6"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "dcf77a38114495f29e64983a60cb3d0e62b0fa645cad60c32fb2357d1a4bf60e" => :sierra
    sha256 "58e90041b8552a2cfc490066330e17839fd848a8fb7b011df4fc4b49fcab927c" => :el_capitan
    sha256 "44eb8e7c5145aec2088c4edf88718b87886f04497dba22160d033e7d680385bf" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse
  depends_on "libtorrent-rasterbar"

  def install
    inreplace "configure.ac", "fuse >= 2.8.0", "fuse >= 2.7.3"
    system "autoreconf", "--force", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/btfs", "--help"
  end
end
