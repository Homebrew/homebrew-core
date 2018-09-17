class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "https://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"
  revision 1
  head "http://svn.code.sf.net/p/lasi/code/trunk"

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
