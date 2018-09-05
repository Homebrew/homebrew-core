class Perceptualdiff < Formula
  desc "Perceptual image comparison tool"
  homepage "https://pdiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz"
  sha256 "ab349279a63018663930133b04852bde2f6a373cc175184b615944a10c1c7c6a"

  bottle do
    cellar :any
    sha256 "1d3d02c27772801105fe9cf3e3ad697bcbeb4db9b260f134bd3e342344455481" => :mojave
    sha256 "683d05fc64186ee518180b56345d446be90ff2c42666c80adb86bc185d20d283" => :high_sierra
    sha256 "eb2da458eda1cebc7872b2621c96e5aa627d9711f8d31fb792cb092d92d060db" => :sierra
    sha256 "d47d680df91ee88897f95123e6b9f972351a603a5f4921726b2877cc2e67924f" => :el_capitan
    sha256 "7a1956479cc1176b7340f4614db1b556318513b6359a025dca942142956b65d9" => :yosemite
    sha256 "99baa893fa0ceaa71fd8c4443a315c2d8e51c567f65a6917eaa5e4ab3952a900" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "freeimage"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
