class Btfs < Formula
  desc "BitTorrent filesystem based on FUSE"
  homepage "https://github.com/johang/btfs"
  url "https://github.com/johang/btfs/archive/v2.22.tar.gz"
  sha256 "03ebfffd7cbd91e2113d0c43d8d129ad7851753c287c326416ecf622789c4a8d"
  license "GPL-3.0-only"
  head "https://github.com/johang/btfs.git"

  bottle do
    cellar :any
    sha256 "d5b103b5b9004549a555352be373c2160bcd5b9f6a8e7e8b030cbf113ae76fcd" => :catalina
    sha256 "bb550107105c612e2c9b81478b352d053f5b8ac8658377e0d40e4ee1109519fc" => :mojave
    sha256 "934b8849eaecd08113b01e222c9583f9293100889f3f40f8452a476a6491e0d0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rasterbar"

  on_macos do
    deprecate! date: "2020-11-10", because: "requires FUSE"
    depends_on :osxfuse
  end

  on_linux do
    depends_on "libfuse"
  end

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
