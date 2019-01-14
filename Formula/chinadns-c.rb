class ChinadnsC < Formula
  desc "Port of ChinaDNS to C: fix irregularities with DNS in China"
  homepage "https://github.com/shadowsocks/ChinaDNS"
  url "https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz"
  sha256 "abfd433e98ac0f31b8a4bd725d369795181b0b6e8d1b29142f1bb3b73bbc7230"

  bottle do
    cellar :any_skip_relocation
    sha256 "61ccebe523d9e2417385c911beca6a01ee7d2810f1a665fca9a4f6a0e7b81623" => :mojave
    sha256 "5b0b51abe8a40dee4b1296e81da179aff05ba42befc869e06e081d7e6fc4e726" => :high_sierra
    sha256 "fa51351f3cdfb63fa672d2011c08ac8a1f9a260bcfaacb13e4657f39e721b96f" => :sierra
    sha256 "a620bce8421a9773233c51886c6845995569a1fda80e252efa86f6271c1d274c" => :el_capitan
    sha256 "329351a4f82e4f871cbc2b384902b0c84040bd1df222970d67be7513bbead207" => :yosemite
    sha256 "4266825a8ecbb6a84d459b41465fe9318a918b171880ac8ddfd8bdf3e37573d1" => :mavericks
    sha256 "c994af6ca279fa06b42ca3a851d550a04d279b2337c06fb21e91a0fe42708036" => :mountain_lion
  end

  head do
    url "https://github.com/shadowsocks/ChinaDNS.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/chinadns", "-h"
  end
end
