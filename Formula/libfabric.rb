class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.9.0/libfabric-1.9.0.tar.bz2"
  sha256 "559bfb7376c38253c936d0b104591c3394880376d676894895706c4f5f88597c"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "ced48c0681d997a48b4a22ac90b5384a782776f088fee98c4d02055e07d399bc" => :catalina
    sha256 "c8313ccf5710f78a8f3c647d3877046db6bbdca758a147007a625679d9fe708e" => :mojave
    sha256 "d038358bc3960dcc5542669bf9d5abd76ae073d45cb147862c8df49d731fb85a" => :high_sierra
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
