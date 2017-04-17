class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.2.tar.gz"
  sha256 "baa25750633a7f9f37467ee43afdf7a95c80274394eddd7dcd4e1542aa75caad"

  bottle do
    cellar :any
    sha256 "036442d258ec7128e6ac6a31f6862afe0aebf16fec6f268a96a32c438e706086" => :sierra
    sha256 "78d19f01354b73e82ccc3a3eb59c45fddf65969b6bf36e307bb7813eeef7c8f1" => :el_capitan
    sha256 "6bb94dda6feae85c407e7779c34f20dc10bd9b2fd377660af7d1c6467735053d" => :yosemite
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
