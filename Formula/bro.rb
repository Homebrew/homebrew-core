class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.6.1.tar.gz"
  sha256 "d9718b83fdae0c76eea5254a4b9470304c4d1d3778687de9a4fe0b5dffea521b"
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "4eaec5d1fc2855bde91148877cfe88a96301cfbae32b7b725d6eb0f01b85cde5" => :mojave
    sha256 "55e8c800317bef47a7e703872e91f0a34e87607b7c9f9f31857770b9530f44b3" => :high_sierra
    sha256 "82cf612f0d7b63fc2a348ccb4f69005e1608db298a592abe7245ec0999bd7a6c" => :sierra
  end

  depends_on "bison" => :build
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
