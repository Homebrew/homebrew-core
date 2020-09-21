class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.2/gammaray-2.11.2.tar.gz"
  sha256 "bba4f21a2bc81ec8ab50dce5218c7a375b92d64253c690490a6fcb384c2ff9f3"
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
