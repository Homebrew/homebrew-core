class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.4.tar.gz"
  sha256 "80daea433fa654f2602cf67b19b9121ff6ad57761bad73cc29020c4f490c5f1f"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "0087cd32977a6bd154531f5cd976c3c281382d14ab4f63331f59a84217413bb2" => :high_sierra
    sha256 "a85ec02f9ba07ae8a91486446a59e2c308cbfe82b2abfe3c05ffdcf4cb3e45b7" => :sierra
    sha256 "618cf877bb6f20ea26183ef3a6d84a2a85c8ec0382890b8ba45749a9243242c3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

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
