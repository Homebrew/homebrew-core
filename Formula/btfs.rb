class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.14.tar.gz"
  sha256 "3f4eb0c2a97c382a72491ca7dbde928c17aa44b76d5992e52c3ce3cf0d4d7f42"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "aa0adc46da1ae7380db57ffc8f39f51841cb504cf75408b9229672b81dfb889a" => :sierra
    sha256 "c117d9c6d93a78ff2f54d6b3739fa253b107361f579763715e15c4e155f87c8f" => :el_capitan
    sha256 "4138de4b883e0ee32042143e85d1aed24aa1e82277e7684fbe4066753876571d" => :yosemite
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
