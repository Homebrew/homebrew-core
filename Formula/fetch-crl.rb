class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.17.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/f/fetch-crl/fetch-crl_3.0.17.orig.tar.gz"
  sha256 "22f460388416bdabdb59d2f8fd423c5b097886649e4a2650867106a7e6c8cfe7"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ed398ad5ea34cb512017c110a07ee60b861a599c81a943e45ab844345f115bf" => :sierra
    sha256 "1ad6f73ea90d63550a76a966db784dcfb5bfaf38af908d8faa8b1a6b1e0fb05f" => :el_capitan
    sha256 "5484c79338f4d5132c26ea4ca10e43bdac7d4e900b448a39d3013590d9ada724" => :yosemite
    sha256 "909169de64f2a03cb1fa0bc5a5ff4128e92dffba0d896c5897a13cb39b428307" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
