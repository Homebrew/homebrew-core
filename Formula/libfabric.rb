class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  head "https://github.com/ofiwg/libfabric.git"

  stable do
    url "https://github.com/ofiwg/libfabric/releases/download/v1.4.0/libfabric-1.4.0.tar.bz2"
    sha256 "e9f449a137d2f1713ffc970f80a9a8c1fd2970f74f1d118941eafd4b2021bc94"

    # Upstream commit from 19 Nov 2016 "core: remove use of clock_gettime(3)"
    patch do
      url "https://github.com/ofiwg/libfabric/commit/0b0c889.patch"
      sha256 "9ed89d80a2edccc84d157e7fa41159e461e8ebefd717db99123b2323df9ae0aa"
    end
  end

  bottle do
    sha256 "91db7ba6edb2403f887680ce9ddb5119bd3e41e0a39a8c4bf7b926c05fad87c4" => :sierra
    sha256 "af0db4773b9ecdacc665747faaaf30e5b7be52f0e7c892196a21a42755d5d2b6" => :el_capitan
    sha256 "9c79ea7f17ce4286abf11c6bdd2c2639bf72ce1588f32f63b611458097f725a7" => :yosemite
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
