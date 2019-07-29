class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  revision 1
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  bottle do
    cellar :any
    sha256 "b528a126a3877d0b76b84cc7d4b2838a4ae17799580ebdfe2a31c9f0a6590256" => :mojave
    sha256 "154d1bf7dc95a9106d2521a73472e868528d98a5b43dae6312ad5d68c9f573b0" => :high_sierra
    sha256 "f9e00255dd8aea2a5094213dc0f6216942cf51920371e19141b5da92a005b5b3" => :sierra
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
