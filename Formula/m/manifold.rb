class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.3.2/manifold-3.3.2.tar.gz"
  sha256 "efdae7cd75aabab20fa2673603a9ac263d5b48912559664dde37f5d9e85eced8"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d8ff8859d3a76f9572d4acf0f547d7f4f419f6902c7ec58fc4facfbfc4bfc4c8"
    sha256 cellar: :any,                 arm64_sequoia: "2887f0c2479448e4e9c90e5b29112551cef7c581907e6dc99d01e86db61f9b16"
    sha256 cellar: :any,                 arm64_sonoma:  "75167f1b674ea31b6714daf717284a120ae25009458793a9a8a4feeb3716b0c8"
    sha256 cellar: :any,                 sonoma:        "0739ab828ac6f351014c0e4cbb9a989e9a88dc9568d92eb753779b38de194669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fccff6f612d40d4f26cc582b7872835c1ef7924726bb33dd0279d3d9f12c2a27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3392442fb8a153d7ae73ac4c712ecb19a3494962f6b9293fe90443df0526aeb2"
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
