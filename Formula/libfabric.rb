class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  head "https://github.com/ofiwg/libfabric.git"

  stable do
    url "https://github.com/ofiwg/libfabric/releases/download/v1.4.1/libfabric-1.4.1.tar.bz2"
    sha256 "fb165fe140a1c1828c49a4780860e669657221a2fc48f28b3934289b5da882a6"

    # Remove for > 1.4.1
    # Upstream commit from 19 Nov 2016 "core: remove use of clock_gettime(3)"
    patch do
      url "https://github.com/ofiwg/libfabric/commit/0b0c889.patch"
      sha256 "9ed89d80a2edccc84d157e7fa41159e461e8ebefd717db99123b2323df9ae0aa"
    end
  end

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
