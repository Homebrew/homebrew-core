class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.7.tar.gz"
  sha256 "e03c36e4933c655bd0e4a841272554a347cd0136faf42c4a6564059e0761c039"
  license "GPL-3.0"
  head "https://github.com/royhills/arp-scan.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "01a5f95378cfa458c106fb3fe0eb723c378ae8dc7b9d2f998c4db81969ec7d81"
    sha256 arm64_big_sur:  "bab165d30f8039bba63d086234d0c57c64152fe73d586081dfaa7eec177fcefd"
    sha256 monterey:       "54cd66069c611ce97b77eaa78e5c321b8a5f7990905ef893026694081c1fec7c"
    sha256 big_sur:        "f3fe2b4b1f70e09f79aaf43b2044068ce5431135a7d7e78ab5022202bfb48ab4"
    sha256 catalina:       "763b615392ea20ab1900bbc4a21fb0a9a978bbf50d3bbd8d5ff490437defc6f8"
    sha256 mojave:         "178196ab4312319611ad02c8e086e56fec2217981f9d91d9e7df8cddfeacda4e"
    sha256 high_sierra:    "f72f46496eecff4c1a86dbdbf3a295e195310827ef50cdc0b007bd7b6311495d"
    sha256 x86_64_linux:   "4e1dce3dfb01c565542caec5dc02683850118f607a7e343e7dfff1eb08c7b627"
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
