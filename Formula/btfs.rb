class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "bb9679045540554232eff303fc4f615d28eb4023461eae3f65f08f2427ec9ef2"
  revision 2
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "16709eafa9575e9b032cbd7a18656c25e23e28b09c9d4ecb1c05f306f57270e1" => :mojave
    sha256 "8d6304dcbbbd2ca488aa930f12afe2b392452c496cc79337d677a9569c8f2ea6" => :high_sierra
    sha256 "d196daadfbfe1670faa9ec72a2071e44cfa5484eca8d018a255cf7223bf56105" => :sierra
    sha256 "53f2962e4a4bad2e1b73eb373cb325655d217e55836ea31ae6f4f56bbdbf4bde" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rasterbar"
  depends_on :osxfuse

  def install
    ENV.cxx11
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
