class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.7.2/libfabric-1.7.2.tar.bz2"
  sha256 "cda00244d1366462a5a020ad8f78782d3e171ec598c408aaeac68a3b5d439f21"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "ee7a6ad88ba710561df9a0f22f13788ca748d3705b1c4abd7e35dc048317ab78" => :mojave
    sha256 "53f47481aebfaac4d9311bbae548541a8267a5081619cb4509652045ca9fc51d" => :high_sierra
    sha256 "5917821fb2f1b096f14855f4df97648134eb2e013c0438a393d97751b2cda36d" => :sierra
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
