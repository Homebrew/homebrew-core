class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.5.1/libfabric-1.5.1.tar.bz2"
  sha256 "7c2b68ab66b0d2cdbd3a9b6dfbe215d84ff281c5e958a603df4ca629da7a78c5"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "37989e2350c12f3cf3e35af87ed5b5dfece4bfd6315174ad4786667c4ca9b5c8" => :high_sierra
    sha256 "03421a38193b23b3fa34f28afcdcad6cc629853658230ed80a4385285583d45a" => :sierra
    sha256 "d714043c9cb25350bc61530f5fddf7a398da353158814f19a9d9377627e1302c" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
