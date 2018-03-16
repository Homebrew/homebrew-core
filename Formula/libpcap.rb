class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.8.1.tar.gz"
  sha256 "673dbc69fdc3f5a86fb5759ab19899039a8e5e6c631749e48dcd9c6f0c83541e"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  bottle do
    cellar :any
    sha256 "68a738a006b2226b2de1af999b2914b018aff21d1822a8be27d1cd83cba08eb3" => :high_sierra
    sha256 "59aa812cdec684990f5b6a4a6243116f728155a52de29ad6b553012b5b4bb75f" => :sierra
    sha256 "d65185154e1d7d34070c0b61855fb2cec6fcf0b47f679135ad3f7c4105acd52a" => :el_capitan
    sha256 "cca6e084403fedada146bd162dade2638a6380733c136bb2e65b6657d5c3fe92" => :yosemite
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-ipv6",
                          "--disable-universal"
    system "make", "install"
  end

  test do
    assert_match /lpcap/, shell_output("#{bin}/pcap-config --libs")
  end
end
