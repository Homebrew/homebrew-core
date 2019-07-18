class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.19.tar.gz"
  sha256 "678831788e3b5e24f674adf87618353bea935fb418d512f17aabe3244f06b7e1"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "70ff35b5db83e4c55d70e1d17c830fc68c34a01f1b85fa83001fa97be32b7354" => :mojave
    sha256 "d9427d71e9b9e39bf5eed697493c64dd1212b38bb6fd8306c200baee00de0f0f" => :high_sierra
    sha256 "1d19a06617a3971728a3e4d22b4b163ddfb4c274ec2169236e007fb0fcea5608" => :sierra
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
