class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.17.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/f/fetch-crl/fetch-crl_3.0.17.orig.tar.gz"
  sha256 "22f460388416bdabdb59d2f8fd423c5b097886649e4a2650867106a7e6c8cfe7"

  bottle do
    cellar :any
    sha256 "1d2f55417dea34e899a6e593bd3b331166ac9937aa8a334dfdf07b3fece96f69" => :yosemite
    sha256 "514023abc5298790e9436a54424da58bfcca3454875f56a7abd33877dc253123" => :mavericks
    sha256 "8e5bc30aea5fcc6e976b525b41a664e25990b074f90d1ff9eaa2437a97b29c13" => :mountain_lion
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
