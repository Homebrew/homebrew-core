class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.2.tar.gz"
  sha256 "4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7"

  bottle do
    cellar :any
    rebuild 1
    sha256 "aa2c32873a7be7b932e74fa4b4674a620f59000a517f4dd7e385a9ab459008bc" => :high_sierra
    sha256 "97db236452fcf5f0292af13c84a97d8ae886202a6134c2259bddb4e6d7e526d9" => :sierra
    sha256 "1ca8b2768eded56f976cd44520b20ece3285127a28fcf46736683897f3275ca8" => :el_capitan
  end

  depends_on "miniupnpc" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system "#{sbin}/sockd", "-v"
  end
end
