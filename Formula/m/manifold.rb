class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.3.2/manifold-3.3.2.tar.gz"
  sha256 "efdae7cd75aabab20fa2673603a9ac263d5b48912559664dde37f5d9e85eced8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a575c8cb9f02762ee83d3afe0bb1ec335e7118695c8b70a89ad18f7610fef32d"
    sha256 cellar: :any,                 arm64_sequoia: "28ef9eda05c7ffb5b45d66b10d2c1919fc7249d56e8e4535bb87356513643ec0"
    sha256 cellar: :any,                 arm64_sonoma:  "0ec5d04b9284d8ba6913a917cd7d61f2bf2c5fdc3cff657f6c695a3a79016fe0"
    sha256 cellar: :any,                 sonoma:        "909aef2c677b05bbb050a7abdf2074c4dfd2464f9b02219ddaa83fc48ab9437b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4daef8aac61d00544783eb6f4b19a9358ff1cafb04250e89afb34d6d33fd2a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3646c3ba29bb5f9417c33a2d3e10d19d88bbebfdf05c9e3a5db85f605cc52263"
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
