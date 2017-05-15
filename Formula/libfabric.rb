class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.4.2/libfabric-1.4.2.tar.bz2"
  sha256 "5d027d7e4e34cb62508803e51d6bd2f477932ad68948996429df2bfff37ca2a5"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "4e2a4c0d2fb8bdebc755da278dbc0795b2dbc5a63d5fd10d4d5354d302f9be9b" => :sierra
    sha256 "161ed93f9280d8963febf33096982a53db604e3be4cf62f10c4e9c15fd083423" => :el_capitan
    sha256 "625c5c11377542f70ca2df2ac95d47a4140fba65d417725c2a99cc481bb63d10" => :yosemite
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
