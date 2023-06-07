class H264bitstream < Formula
  desc "Library for reading and writing H264 video streams"
  homepage "https://h264bitstream.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/h264bitstream/h264bitstream/0.2.0/h264bitstream-0.2.0.tar.gz"
  sha256 "94912cb07ef67da762be9c580b325fd8957ad400793c9030f3fb6565c6d263a7"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fd917379072e27703bae053f19aefc1abbf328dfcf5857e6aa4192babe3fc48"
    sha256 cellar: :any,                 arm64_monterey: "21fef413b7c8c4ae235dcdd1aba11a77553cd382f74d328c5958ba7e6ed47c39"
    sha256 cellar: :any,                 arm64_big_sur:  "86d9c15b08de87f85f791e45669241a1a27fefef2ddbccf6016642505e69c6e6"
    sha256 cellar: :any,                 ventura:        "befe3309e1c2b4670bd77c741ac73abadcbb23fab0199422b61d901111fae7b3"
    sha256 cellar: :any,                 monterey:       "65af04578c1f21572695b045a268c8de1f3e8592dde3c407a2cc0c9e5aae797f"
    sha256 cellar: :any,                 big_sur:        "2ace75ebe5094b847024fb80a23a82bba3acfa7869399f3962c6910089ebc777"
    sha256 cellar: :any,                 catalina:       "ac1f452b4c4d4d90310ec1f3cd9ec45271665604844dca55df3f7a91885d28d7"
    sha256 cellar: :any,                 mojave:         "ebe66ef0a10e2afacf2b418eb15aa57ed873c6df73d6da71b6252efce8c15a5e"
    sha256 cellar: :any,                 high_sierra:    "191acedb64e2ab618696fe16c55b81cdadb9819a0b0fc594235d31a28a1cdf96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c79de8d86abcc4f3f95f8bd7a504116fe189546101cec66d52ab6295bf0bf376"
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
