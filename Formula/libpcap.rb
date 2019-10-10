class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.9.1.tar.gz"
  sha256 "635237637c5b619bcceba91900666b64d56ecb7be63f298f601ec786ce087094"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  bottle do
    cellar :any
    sha256 "3dd52bb4392991c31e51e72f12ac6965329cdc1b6b0c838d5766d094c2b07e6d" => :catalina
    sha256 "3ab6fdebfed54c872fcbe453ec11234c945a721df24f48e2f637fd941d9c2ce1" => :mojave
    sha256 "e8019b8b1da4a7fb7cd4ff0ec13fc1b965fec0f9de8e578a21d18118f87e66de" => :high_sierra
    sha256 "34028b7962e0e4e8f6b2dad9c9178b806561df378c617bc5cb5f3b0cad69559f" => :sierra
    sha256 "49bb47a85517db11021d3717f87e5c834eeca830d3929e83a836e7a916df6c36" => :el_capitan
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
