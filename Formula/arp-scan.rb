class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.7.tar.gz"
  sha256 "e03c36e4933c655bd0e4a841272554a347cd0136faf42c4a6564059e0761c039"
  license "GPL-3.0"
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    sha256 "763b615392ea20ab1900bbc4a21fb0a9a978bbf50d3bbd8d5ff490437defc6f8" => :catalina
    sha256 "178196ab4312319611ad02c8e086e56fec2217981f9d91d9e7df8cddfeacda4e" => :mojave
    sha256 "f72f46496eecff4c1a86dbdbf3a295e195310827ef50cdc0b007bd7b6311495d" => :high_sierra
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
