class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.17.tar.gz"
  sha256 "80a5a3ad48bebf13441d506755b2402ac230dc3f1f648ce12d3855e5cf04e53b"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "e7f26c26ff8aecf7840e02102448330338aab441789196c4ff608a406f0d2d06" => :sierra
    sha256 "db94dc535dbefc3a813092153284fe078bcd26a05bef6dd85c1e55cc19ef3655" => :el_capitan
    sha256 "fcc7ff1c76c85cdbda0cea85bc2bad01adf785196a79c7f7d56beef53d11694c" => :yosemite
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
