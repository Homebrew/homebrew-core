class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.20.tar.gz"
  sha256 "ab85d10407d210c367dc5a0db6aa9e8620ebbb819c58da783ca343dfa8577441"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "7b3b691544cdf1fc4d7a88f5ca5b2bc630d636b79e65391eceda02015ed817a6" => :mojave
    sha256 "dab4673f1e3f5b5b3f0200e9ac252e5124bcb4702fe52735da85eec9d8dea26e" => :high_sierra
    sha256 "457c198406251b965f3fff02f8910dbfb30988210a0ff6e7e2fb5b1c8d4ea601" => :sierra
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
