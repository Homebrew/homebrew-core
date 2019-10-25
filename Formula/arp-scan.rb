class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.6.tar.gz"
  sha256 "971b45c3369816467994797fbcd0076eb8f0ffb9c42764ea6dba25ab3fd490da"
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    sha256 "6b6621b80ffaccbbbd1f9942e7279ac786aaa258003980c6111e27d49ab199d5" => :catalina
    sha256 "d17e1ad7dac154571c7e48fe2d9aac7b0555c10a60c1184ffc8b273e5b1238a7" => :mojave
    sha256 "e6dbdf4a4c2cc9f42012c76192bf562858aa8838895cda7e507543497b253003" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libpcap"

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
