class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.3.6.tar.xz"
  sha256 "1e5a7a7820c493aa62b0f35e15b4233c792cc03458c55ebdfa7a6521e4b43e9e"
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    cellar :any
    sha256 "7d69a43858af582acc49663e2e464ce6e361b99e33f58ea8fcd605df02f60128" => :high_sierra
    sha256 "72ea79b1b694d3ba054af56ed8aef46957e9ca2cb71642a0c9576121d1333e48" => :sierra
    sha256 "07ee02f2d332d60c9377117e47471f44ef7843de0f162acd067fe732f4d23c1d" => :el_capitan
    sha256 "c2d4a00cc8e80a2969fa14cb71a84f0e3e26342402c77fdbc641b2e48fec851e" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
