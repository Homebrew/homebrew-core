class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.5.5/manifold-3.5.5.tar.gz"
  sha256 "5b5bb677e819a73a7b4ac96bbf95d35120b2fc324bb22446a6b717a30bca82c0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "96463d4c0f291b6c43382cd7cbc78ab7809980b60fee687dccc84445bd66cb2f"
    sha256 cellar: :any, arm64_tahoe:       "92cf4b4030030ec231dc82327bf9c12def686139f820fd498448caa0c4c71ed4"
    sha256 cellar: :any, arm64_sequoia:     "9878b4fd166bd47ccdbe4ae74e53de229491d71eb7118eb37155c1a0d47ccfb0"
    sha256 cellar: :any, arm64_linux:       "bf9c2499bd1016da38aaa81f91b9437184ccc543cbd4818238fa99a9e404996c"
    sha256 cellar: :any, x86_64_linux:      "af65b5a750d0e3a5e41b6e9ba3409e274b544c2939a9c31911b64a853e2de901"
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
