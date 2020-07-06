class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.21.tar.gz"
  sha256 "b170d01e362f34038a9bacf75f63eaab85093c1fd296c4f9ed17092f5ca2ccfa"
  license "GPL-3.0"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "6a3bfd9986dbb880ebbaf773ee60888e3473454abb359dcd020225ff0f400a21" => :catalina
    sha256 "e7fe05d4c76e29b94cb3c91efa5769913a712dd14e6775379416f6f725e742ba" => :mojave
    sha256 "dd76719f3c295e8750f1698519599384deda75a1598957dffaf1fd92384ef6dc" => :high_sierra
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
