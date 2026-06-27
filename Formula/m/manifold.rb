class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.5.1/manifold-3.5.1.tar.gz"
  sha256 "ed24f72b97beb18e05a14539febbb850dfa8d4f3f67127ebeca5ff68f6a00a5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2dfea46a6fbd8ac654883a5197aa342000b95bc3d1b5ed5809000ce928ff7793"
    sha256 cellar: :any, arm64_sequoia: "bf91d2eb4b6f19670db3e1c8a51f85973f3f546ff3c14f4436355ca836c30eec"
    sha256 cellar: :any, arm64_sonoma:  "27a5f82c21f876211ecc6c955e6f3fce04526a3e0610f2d41c6d68b860b03f58"
    sha256 cellar: :any, sonoma:        "e25ccebd664e977d5f547bfec0bbaecee749e2ea6fb901a2805d20beb5d02722"
    sha256 cellar: :any, arm64_linux:   "6829ef35f75a54ac0c361e446c1ac66589a23d60ca7d48d295d39b926f5382fd"
    sha256 cellar: :any, x86_64_linux:  "3b091fc96d146fb9e57d2aac79103fdc8feb9cfeb3a2706170d04f42abe58706"
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
