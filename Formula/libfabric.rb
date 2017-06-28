class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.4.2/libfabric-1.4.2.tar.bz2"
  sha256 "5d027d7e4e34cb62508803e51d6bd2f477932ad68948996429df2bfff37ca2a5"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "315ae9c4dbd25decbd986727818a7783ef20345c38d7181fea5f73280c39dde6" => :sierra
    sha256 "a558f70ca027a71bfca91e4be73bceba31988e83e9e8ec979be4c2866226640b" => :el_capitan
    sha256 "b3860291617118a4fe639ff910ddc42a91773e3150a9ede7ddb015eb8525aaf4" => :yosemite
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
