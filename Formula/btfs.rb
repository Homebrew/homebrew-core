class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.18.tar.gz"
  sha256 "faccec8715ed2dd2193ae4e026c1735ff354bba635b9bb60d2642e2895aa5674"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "b52f7ee7ad70df58e4cf73135c86d5b87d5a8544ed1cc3f0b2b656af83a83fb0" => :high_sierra
    sha256 "babf16ef8cda16858eae0ddf26dd84cb9ed31513b43b94dcea1d6e8d9f2291ff" => :sierra
    sha256 "bc039ad8c3115de4a4111c271dc19ce4e2f014eea5336d3c42433b33fadd872e" => :el_capitan
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
