class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.8.tar.gz"
  sha256 "b9b75ceaef6348f5951b06c773ec7a243a9e780e160eafebc369f9c27f6a7d3f"
  license "GPL-3.0"
  head "https://github.com/royhills/arp-scan.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "97e75dd94f16bfcdf8f65ebc0ff7c625f1cc9740ecbaadb12e20d7232a619344"
    sha256 arm64_monterey: "889266ef3963fb2877df0a3445149d798c87f9317f493655598dd7cb540963a7"
    sha256 arm64_big_sur:  "7d615e04cb2b99c9dfc38f0a58d35914bc6d2fc85e2c2beb16a4f8deacac1791"
    sha256 ventura:        "107a9a124119b6f2f5ee0c722d9b32941b139b12419876035f341470986c3a8e"
    sha256 monterey:       "0628ba78ca4469f86e41315df57427b976e30985e6af04d09b9111c27b772b6b"
    sha256 big_sur:        "1c554bca28b60b7695a14ea881b6d73d8b434fa0991b1688e26c17fa5b23d334"
    sha256 catalina:       "a2c73c508390e1871339f892bfadeb677c0e564bd59c7a9abd003946cbf8b333"
    sha256 x86_64_linux:   "a5eda727915c262f7a5c9be0599785afd197b89e48bbc8fefc1fb2d81163d1b8"
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
