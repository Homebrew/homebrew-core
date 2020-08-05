class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.21.tar.gz"
  sha256 "7bf550571aa1d4a2b00878bb2f6fb857a09d30bf65411c90d62afcd86755bd81"
  revision 1

  bottle do
    cellar :any
    sha256 "24cb6f161d06e9f2bc38d819a7d724d3f0d337f322cbb6e5b685118829e6cd32" => :catalina
    sha256 "19a737592d390d0bdf06e03c1a49e22a2d9860e065153e1b84bd325fcfa7640c" => :mojave
    sha256 "5019bb51a8cf372fd070b0b2686a3bbb2b7c262e2d39c8cae83d0c384971a82c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/arping", "--help"
  end
end
