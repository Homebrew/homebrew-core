class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.5.0/libfabric-1.5.0.tar.bz2"
  sha256 "88a8ad6772f11d83e5b6f7152a908ffcb237af273a74a1bd1cb4202f577f1f23"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "636003a9f03bd507340c0583f5798a8382d37357d4725b494df1e1d37010570f" => :sierra
    sha256 "0268dd158761aa12c821c3553e3d90469e6102d410e00c94fb52063af4c1af1b" => :el_capitan
    sha256 "aa9e0ca7778056e27fc156a2c427ea9c3284d853486fc767974e6fd449bf8d01" => :yosemite
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
