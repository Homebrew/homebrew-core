class Arping < Formula
  desc "Utility to check whether MAC addresses are already taken on a LAN"
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.19.tar.gz"
  sha256 "b1477892e19687a99fa4fb42e147d7478d96d0d3fc78ca4faade6392452414db"

  bottle do
    cellar :any
    sha256 "1ad01f9bf993312c04c2b67d9b0b975e20ea017a88d771b6ab0dafab9ad35114" => :mojave
    sha256 "10814e4189c25dd909346c39ab9b504244596a8b09dffc9d7ca91272decfded5" => :high_sierra
    sha256 "fff7a3fa700564778114ad421446a48fedd06e252074c6be66e2c4102e538ec4" => :sierra
    sha256 "e60c8221e95db34d5d2a66039d229e242f194b05e22aa4ebdefd7b06cd00fb74" => :el_capitan
    sha256 "cca37d86bc0c93413cd9b1d9259113c21e7b512c780f1e74da71f981e3986c8b" => :yosemite
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
