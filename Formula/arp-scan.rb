class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.5.tar.gz"
  sha256 "aa9498af84158a315b7e0ea6c2cddfa746660ca3987cbe7e32c0c90f5382d9d2"
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    sha256 "7feff35163c765888d5d5d9e729d1a54e3310e13ff8bbc2decaf2e9ce3d90679" => :high_sierra
    sha256 "9f09dcbe83bd1f139911b531a123b5cf05a64f6006fc7de52f5d1d8496c46709" => :sierra
    sha256 "4bda8ae4da7c735c08d45cfa7fc58987413e6600267f9e5ae7f4cfa5d174599a" => :el_capitan
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libpcap" => :optional

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/arp-scan", "-V"
  end
end
