class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.1/gammaray-2.11.1.tar.gz"
  sha256 "87a1d72ad1ad6d1a0156c54a85b0976ab38c6a64136458ca7c4ee491566d25d0"
  license "GPL-2.0"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    cellar :any
    sha256 "d43f04f5d9d8f0f26ff7ec8164b8a6a6397174e56476a60abf7f592a5e8ef2d8" => :catalina
    sha256 "daaad613868d4159d40b7c954dfca613ac68a6cbd75e1471d35e04958ff5ae16" => :mojave
    sha256 "652ed0574b07f8e0bffa9b7927c718295cbc4d1e5b69148101923d8edebcf406" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  def install
    # For Mountain Lion
    ENV.libcxx

    system "cmake", *std_cmake_args,
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF"
    system "make", "install"
  end

  test do
    assert_predicate prefix/"GammaRay.app/Contents/MacOS/gammaray", :executable?
  end
end
