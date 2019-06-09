class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  bottle do
    cellar :any
    sha256 "d984a3671e296dcaae8d90f81fd2701fde96dd906ab4405a5977636271c0e7cb" => :mojave
    sha256 "e6cb8e9194401b281f6b60da923bb0ce413d861744cdcb30fd0f773097fa4b27" => :high_sierra
    sha256 "9e0bac16a19064d3fd91ef63ee3ea679edf7cab0d2f060f9b42527a8564a43d1" => :sierra
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
