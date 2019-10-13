class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/1.9.5.tar.gz"
  sha256 "aa9498af84158a315b7e0ea6c2cddfa746660ca3987cbe7e32c0c90f5382d9d2"
  revision 1
  head "https://github.com/royhills/arp-scan.git"

  bottle do
    sha256 "f1130fa47480129484695c806726984e631d45de9a503ec4c3abc3221c806bd1" => :catalina
    sha256 "b2b784e3577ce342c80a646428ebb672971a532679791467b009493e048896f8" => :mojave
    sha256 "bc0fdf16b93e8793cbe2bc820969b167ef54df05d25e2d1f9162bda984768241" => :high_sierra
    sha256 "8e372e2939b71602ed646c55ccf80a8a17f16e00c25e3eb2a7a273a7df19a487" => :sierra
    sha256 "15502dca99f62348373e10510432ff389170fa4b1cbf40a52b546e3c5beecf40" => :el_capitan
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
