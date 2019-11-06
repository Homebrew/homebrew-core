class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.9.1.tar.gz"
  sha256 "635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  bottle do
    cellar :any
    sha256 "3a85693ff5d241ccdc689af9fa1281434ddf6ae3d0887cd679d07bbc1730ec29" => :catalina
    sha256 "57ec7b7a786335d818c7eaca81a834c5ca9f4865a91df78b621d6b5d586cf859" => :mojave
    sha256 "26028b66ea5395a0eee75ebd5790e9d3a688e83698631aec328224bb7baa6037" => :high_sierra
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
