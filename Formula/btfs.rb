class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "faccec8715ed2dd2193ae4e026c1735ff354bba635b9bb60d2642e2895aa5674"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "2eedcda32260752e93139eeb949b8ce4100839ab1502c3243ed51b67eb496463" => :high_sierra
    sha256 "0709114aa5da5de99d8c745680ba14a3b8edec6b422828d10a541c03478fe2a5" => :sierra
    sha256 "5613f37b2291a400c017c28ab67bdb25c21df0afefee98f7c8b00ab374bb2a79" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on :osxfuse
  depends_on "libtorrent-rasterbar"

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
