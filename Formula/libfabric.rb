class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.10.1/libfabric-1.10.1.tar.bz2"
  sha256 "889fa8c99eed1ff2a5fd6faf6d5222f2cf38476b24f3b764f2cbb5900fee8284"
  revision 1
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "abf3b135a763ce34e818435e3b3b071f4c9aeea48d62bf22ffdae8432a55103e" => :catalina
    sha256 "fdeab4a76a5ee87946a2d76b9e4a8f3b8960c8d3d2fee0d1058a5363ed3f38b8" => :mojave
    sha256 "06e8fca360c7be76f060f23569defe285175f8d4dbe889bce0e2fe2d552b1a25" => :high_sierra
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
