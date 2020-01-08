class Mergelog < Formula
  desc "Merges httpd logs from web servers behind round-robin DNS"
  homepage "https://mergelog.sourceforge.io/"
  url "https://downloads.sourceforge.net/mergelog/mergelog-4.5.tar.gz"
  sha256 "fd97c5b9ae88fbbf57d3be8d81c479e0df081ed9c4a0ada48b1ab8248a82676d"

  bottle do
    cellar :any_skip_relocation
    sha256 "41acae4f1614c4ba0a3ea3e05bb88c150c930a07c50560df1d4bfc4a49c9bdf1" => :catalina
    sha256 "31d639e39928eee4373d5b18b619d168e02da3021e02d4d01e07209244d7712a" => :mojave
    sha256 "87f4253bd8e0d556dadfabcb376d4f138d6d07a5884c331074692b21cff16397" => :high_sierra
    sha256 "8f74bd002165acfb3009054be72f89794c11427194bb4bda229ea1c55fe0f4fb" => :sierra
    sha256 "70f188fb9d576b86d968a82bc5b19daabeb17660a2fa155b31b1006d27767deb" => :el_capitan
    sha256 "0c8abf1099d637be9dc4398c6fdde6cfa8a09c71fdb89546b546913a1a9d3868" => :yosemite
    sha256 "e0eeb25b7eeb7fa532e2c950efed15aa6d9d9880530888cf1796a02fd5839eff" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/mergelog", "/dev/null"
  end
end
