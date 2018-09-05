class Libpcap < Formula
  desc "Portable library for network traffic capture"
  homepage "https://www.tcpdump.org/"
  url "https://www.tcpdump.org/release/libpcap-1.9.0.tar.gz"
  sha256 "2edb88808e5913fdaa8e9c1fcaf272e19b2485338742b5074b9fe44d68f37019"
  head "https://github.com/the-tcpdump-group/libpcap.git"

  bottle do
    cellar :any
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
