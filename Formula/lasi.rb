class Lasi < Formula
  desc "C++ stream output interface for creating Postscript documents"
  homepage "http://www.unifont.org/lasi/"
  url "https://downloads.sourceforge.net/project/lasi/lasi/1.1.2%20Source/libLASi-1.1.2.tar.gz"
  sha256 "448c6e52263a1e88ac2a157f775c393aa8b6cd3f17d81fc51e718f18fdff5121"

  head "https://lasi.svn.sourceforge.net/svnroot/lasi/trunk"

  bottle do
    cellar :any
    sha256 "777226a80b3fad497241ea6810d16d39846a4ff2d51acea4d4924cb44751419b" => :sierra
    sha256 "35a95d3bf2ad71999df616c06417883d25d22f343a40ce3a27b6a3fb11c1e689" => :el_capitan
    sha256 "4e1c3dc744e265709bc196acc936d8bf4307196972a772130a812c8c7bb1a80b" => :yosemite
    sha256 "31c9f3a86877476a4c1c6fbdd8c6064512cf3aebc50b25bf0be53a1b5ed2ba1e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build
  depends_on "pango"

  def install
    # None is valid, but lasi's CMakeFiles doesn't think so for some reason
    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]

    system "cmake", ".", "-DCMAKE_BUILD_TYPE=Release", *args
    system "make", "install"
  end
end
