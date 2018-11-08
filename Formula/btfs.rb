class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "bb9679045540554232eff303fc4f615d28eb4023461eae3f65f08f2427ec9ef2"
  revision 2
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "e03434b33a6b3f27436b7e31e22696d3c645c27840729559b156e42ac4f99715" => :mojave
    sha256 "cd5cffcddc4a7a7013fd7a38edba49b70c6bb9dc6ef965db0d003682d2a032c3" => :high_sierra
    sha256 "b5bda19961ac5e3e9729c16ee6b39de5370fc462cbffac63823f7ba0f174548e" => :sierra
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
