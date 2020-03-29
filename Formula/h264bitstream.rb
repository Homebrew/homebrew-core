class H264bitstream < Formula
  desc "Library for reading and writing H264 video streams"
  homepage "https://h264bitstream.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.2.0/h264bitstream-0.2.0.tar.gz"
  sha256 "94912cb07ef67da762be9c580b325fd8957ad400793c9030f3fb6565c6d263a7"

  bottle do
    cellar :any
    sha256 "ac1f452b4c4d4d90310ec1f3cd9ec45271665604844dca55df3f7a91885d28d7" => :catalina
    sha256 "ebe66ef0a10e2afacf2b418eb15aa57ed873c6df73d6da71b6252efce8c15a5e" => :mojave
    sha256 "191acedb64e2ab618696fe16c55b81cdadb9819a0b0fc594235d31a28a1cdf96" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-iv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
