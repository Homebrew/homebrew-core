class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.5.tar.gz"
  sha256 "1502a290d3663fa67a44ff6c1c8e8e9434b8ae5e76be5c2a02b06a0e391dc080"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "a6b66a970ca73b318aa935bf20a3e6e1dcaf68d23968e51dea8fc560ea010731" => :sierra
    sha256 "6612eae519dab37befbd544b11d95e39bdbf69bbb0a2fb2b056448405b438d8c" => :el_capitan
    sha256 "4d0e48df72688a2b1e21808da0a51f6d309e62b7119e9a5f69cabf399fa04b1e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openssl"
  depends_on "geoip" => :recommended

  conflicts_with "brotli", :because => "Both install a `bro` binary"

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
