class Libstatgrab < Formula
  desc "Provides cross-platform access to statistics about the system"
  homepage "https://www.i-scream.org/libstatgrab/"
  url "https://ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.92.tar.gz"
  mirror "https://www.mirrorservice.org/pub/i-scream/libstatgrab/libstatgrab-0.92.tar.gz"
  sha256 "5bf1906aff9ffc3eeacf32567270f4d819055d8386d98b9c8c05519012d5a196"

  bottle do
    cellar :any
    sha256 "d3a41dfe112e21467ce51134b576e14678f982f1c838b6b624d96ad46edc7c88" => :catalina
    sha256 "bb1778c08b1b91cff873016e3a6f314d3a97a55db378e0870354bb64337ea50b" => :mojave
    sha256 "d7d932298fe68980389bf5b2c8f1d6ef41a6037630b4951996139c2277fbf6f4" => :high_sierra
    sha256 "17efc663227f42859add13c81e0b5fac1f3f3a0418c3d15b83363ea90c0b4a91" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/statgrab"
  end
end
