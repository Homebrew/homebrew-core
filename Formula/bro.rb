class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.5.tar.gz"
  sha256 "18f2aeb10b4d935d85c115a1e4a93464b9750be19b34997cf6196b29118e73cf"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "93bc629294d559b5ef2b4a68ef07aa9b27332c850f70b23a9ea58a18fef00029" => :mojave
    sha256 "e8c73068493bcfcdb6ee42569acf1472c936cc88b9947549728987b98d0678d7" => :high_sierra
    sha256 "45e7f85b63de0658c6fd67b2bc032c73e7e1b41d0dd7fc5252ff400c56071747" => :sierra
    sha256 "d1a8841214d9cf4d4fcb0916c568ed763a8c385a01f28fd394025aafebbcd971" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "geoip"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
