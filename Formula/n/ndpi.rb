class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/refs/tags/4.4.tar.gz"
  sha256 "5df3a7bc251e3838079c403707334c1cd93f20c17b33e31e090f30a16adb3702"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fd20040e0ccba85f6c43d0c7f340999f31e1ea7da8dda685bf3b7ba464fd990"
    sha256 cellar: :any,                 arm64_ventura:  "b5ca45fa0c2b9221ea7faa228f3a85ccad3d073440babd8af2ad2ad3dfc019e0"
    sha256 cellar: :any,                 arm64_monterey: "dbcc91245b69a0a75a6977ba1c8d730d6e76820e1df0812a3f77a5fa0b0d3962"
    sha256 cellar: :any,                 arm64_big_sur:  "381c57b01561973cf2b1ac45a84e4927dacd9d04a07823962c0a1bb4b9efff55"
    sha256 cellar: :any,                 sonoma:         "c5c6f870cf6a0adb032e1d31c5c5d501549d3c504c789763e38559299b8d1684"
    sha256 cellar: :any,                 ventura:        "32d7e364d7726050158a78edf84aa7168fec54ac6848fada7a9c4aaad6cb329b"
    sha256 cellar: :any,                 monterey:       "90c3f2b4e31d68484a6a029f97bebb5e380c6aaf19e50204c826d318d86712e6"
    sha256 cellar: :any,                 big_sur:        "9dd1bcc427eae093ad10faa9ab925e8ec6a91d4e785e41adf9908b9c9cba9e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356839f65ccf946b05ed44494af3b7f5621e5ec8bad8b77237965fb7bb3dd9c5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
