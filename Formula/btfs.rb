class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "bb9679045540554232eff303fc4f615d28eb4023461eae3f65f08f2427ec9ef2"
  revision 4
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "879453f88edbd5191e9d4e68e84673540417a6bd745408d552daefe1c6abf373" => :mojave
    sha256 "84e0f21615858292dc1c121af6404b53b17710b57262945b5bc96abcc686d5f5" => :high_sierra
    sha256 "ac6679fae6ee86dd2ca520f92c347ff70967c2d08d99031540cd9a862cb11d6c" => :sierra
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
