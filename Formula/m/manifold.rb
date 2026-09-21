class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.5.3/manifold-3.5.3.tar.gz"
  sha256 "9545a1c944280673553d0c97602def29f62afa4ade4b27ad1593bb13aa266218"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b06040c680658f13d36962b8723f290e06e5ed4f4304553d3a8e44be6172c1ed"
    sha256 cellar: :any, arm64_tahoe:       "9eaab1ca48b509ea46b43cc3e412aec4cbe54e3aa19d0ce61a9aa569571a54ce"
    sha256 cellar: :any, arm64_sequoia:     "ee1be82c302c917eb5a393985855ce65cc80ba1367c47fbfa29bbafe01c5ca35"
    sha256 cellar: :any, arm64_sonoma:      "8a437b6231805efe81b3735f6fed3bc836727440f2aa2195829fda43146ce05a"
    sha256 cellar: :any, arm64_linux:       "b5aad5b9066104c0094b27a9e1ce6581e51f772c1a82dcc2a32d8dd66dd80c65"
    sha256 cellar: :any, x86_64_linux:      "88bb82301c2dcae6577378e71e80d3dbcc831352b3c79e1633414a7ba53d55db"
  end

  depends_on "cmake" => :build
  depends_on "clipper2"
  depends_on "tbb"

  def install
    args = %w[
      -DMANIFOLD_DOWNLOADS=OFF
      -DMANIFOLD_PAR=ON
      -DMANIFOLD_TEST=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "extras/large_scene_test.cpp"
  end

  test do
    system ENV.cxx, pkgshare/"large_scene_test.cpp",
                    "-std=c++17", "-I#{include}", "-L#{lib}", "-lmanifold",
                    "-o", "test"
    assert_match "nTri = 91814", shell_output("./test")
  end
end
