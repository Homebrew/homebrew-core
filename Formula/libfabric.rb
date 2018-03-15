class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.6.0/libfabric-1.6.0.tar.bz2"
  sha256 "b3ce7bd655052ea4da7bf01a3177d96d94e5f41b3fd6011ac43f50fcb2dc7581"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 "6a7144a460b1df95ae5abb9b7667074c2c75abfa41f6466f1aabc7109e518ab8" => :high_sierra
    sha256 "9444011fbd9790de55db71e01cd99125b7352552416835a746cde86edf612f74" => :sierra
    sha256 "63bcb93bad276f3881c1bbc2b6fc15cdcf686ee4cdd4d8bdeb3d2300999e7c51" => :el_capitan
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
