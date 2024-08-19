class ArpScan < Formula
  desc "ARP scanning and fingerprinting tool"
  homepage "https://github.com/royhills/arp-scan"
  url "https://github.com/royhills/arp-scan/archive/refs/tags/1.10.0.tar.gz"
  sha256 "204b13487158b8e46bf6dd207757a52621148fdd1d2467ebd104de17493bab25"
  license "GPL-3.0"
  head "https://github.com/royhills/arp-scan.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d98ac1c8bbec39883366864095c7468571c48b3a2f92a8a8326e992b143cc9d2"
    sha256 arm64_ventura:  "fe21f7f459c6191776b16a3887bb36477026e82c99a41822eb8d0c5a1b9e53df"
    sha256 arm64_monterey: "22a509abffd38b079fcbbe1626784b892ef9d4a54b4a185bcb3d07b2557ecb73"
    sha256 arm64_big_sur:  "55d92130a060b97994ed9a3007597ff0e6beb8db436d4df6107e8233e02254bf"
    sha256 sonoma:         "e6e155812a6af49ddbe9cb468c473340498936c2c78336c678c3120c59d6ffdd"
    sha256 ventura:        "5e3188f83074260c43c50ca061100949388f8a0f0278a2fd98fbd45dc445044e"
    sha256 monterey:       "1eb810add3b6a2caaeb0d82ede9a7fee13ae4d279c32aa085de0e4ee04c90df2"
    sha256 big_sur:        "40a2785e1f1cb92ae991ea335abf3fe73cedbd5758cc5e296c3360d60368b3b7"
    sha256 x86_64_linux:   "6a24edcaa75d9069428f7d1a185d38c0ad1dbc5cc48bc98e9098900825a6806d"
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
    system bin/"arp-scan", "-V"
  end
end
