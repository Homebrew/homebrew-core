class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.5.5/manifold-3.5.5.tar.gz"
  sha256 "5b5bb677e819a73a7b4ac96bbf95d35120b2fc324bb22446a6b717a30bca82c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2c1648d5ddc125b37587bae18913e595923763fd2d855545098bf2942970d6cd"
    sha256 cellar: :any, arm64_tahoe:       "035463fffc2669c81c5d36d6bd43d79e57cccbccc1602110883f4c7852841750"
    sha256 cellar: :any, arm64_sequoia:     "36c711a6404b9a5259a097ab7ac27bf16e1be19481d92f15d14429288aba57e1"
    sha256 cellar: :any, arm64_linux:       "902f350b95e81df9a7e79847051b508b7040646e7db085803fa631065fa07c08"
    sha256 cellar: :any, x86_64_linux:      "e6ddab434b05ca10b42829b3d8ba1dc6ecf4a4bab1442fa87848578f3bae0d28"
  end

  depends_on "cmake" => :build
  depends_on "clipper2"
  depends_on "tbb"

  deny_network_access!

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
