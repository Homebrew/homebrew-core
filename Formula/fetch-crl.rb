class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.19.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/f/fetch-crl/fetch-crl_3.0.19.orig.tar.gz"
  sha256 "64d8f573601568554415c9ad853864285313538a90de92b3dcf2d16b92b2bcde"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8907b1d805f5bf782f4b9fbccb225b66104631269f0d4b69488518b12c919f2" => :sierra
    sha256 "66c8bbf8a0971d925e3b92b4f3dee740ebee385aa9f7b76974b62d1eaa9e7672" => :el_capitan
    sha256 "66c8bbf8a0971d925e3b92b4f3dee740ebee385aa9f7b76974b62d1eaa9e7672" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
