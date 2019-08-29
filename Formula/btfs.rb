class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.20.tar.gz"
  sha256 "ab85d10407d210c367dc5a0db6aa9e8620ebbb819c58da783ca343dfa8577441"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "f968ed2760568d58d6bf17a197e156f373831f118275ff4693a4e69bc4406d50" => :mojave
    sha256 "25b15a99efc6f97d2b1805e55d247fec99fc6ce951e7316543177fb426898094" => :high_sierra
    sha256 "0b8f732f89c7e5cda2de3c0c5f873ad0bc8a7bc2caf4902c5265d2de81f4d4e8" => :sierra
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
