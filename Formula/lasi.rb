class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  revision 1
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "65a46c00e8cef9b98bf1b36229a3da7cf69038b5e1d8cccbb620cb1431d27319" => :catalina
    sha256 "5ef18cc43b46bf548f42925b3b2beb4993461ba78d5078f1cacaf8ac7b7af169" => :mojave
    sha256 "447ee1c538c34cb9f06c5dc743ad86807ddb4e05ea6e345b6db085705324da6d" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"
  end
end
