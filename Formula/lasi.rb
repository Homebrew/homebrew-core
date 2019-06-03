class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.3%20Source/libLASi-1.1.3.tar.gz"
  sha256 "5e5d2306f7d5a275949fb8f15e6d79087371e2a1caa0d8f00585029d1b47ba3b"
  revision 1
  head "https://svn.code.sf.net/p/lasi/code/trunk"

  bottle do
    cellar :any
    sha256 "70047a220f5761a9269d7aa9bc9130c9a048b62966efbcd78bef6b4011e254ce" => :mojave
    sha256 "3046c6587163febbdc84a38059fc87bb9bbee3c07ec092786b0f5565a914d759" => :high_sierra
    sha256 "31c08380140531a70f3fa53d7026ff8b356508c8643ec1751e26261f1d663438" => :sierra
    sha256 "85883793893dce87446ac03902394857c5b945b90c42a66eccc48366c5868401" => :el_capitan
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
