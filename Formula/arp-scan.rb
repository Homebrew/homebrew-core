class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.5.tar.gz"
  sha256 "aa9498af84158a315b7e0ea6c2cddfa746660ca3987cbe7e32c0c90f5382d9d2"
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    rebuild 1
    sha256 "4e50c7a232cda92445d0c030072e71af84271322edb03d0718d89e92eb76e577" => :high_sierra
    sha256 "70a15f93ba09a4201352165594b2d69d3537fb55ba7c0180619470c2235bb851" => :sierra
    sha256 "f0fdab57a9d16dc270b9bedba6c5cca5e99e2b5319268261a320dda86fa5da54" => :el_capitan
    sha256 "4a26a7bb3c586122b4aad81c17bf8427bc820ec4a4353573ffedf79087000232" => :yosemite
    sha256 "e0570d20ec6c79c1a43c9925eb5c09d7ab9589fbe9d2ce1579927800ac6c53d5" => :mavericks
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
