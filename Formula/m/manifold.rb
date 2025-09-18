class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.2.1/manifold-3.2.1.tar.gz"
  sha256 "67c4e0cb836f9d6dfcb7169e9d19a7bb922c4d4bfa1a9de9ecbc5d414018d6ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "84b1af9336b1e9039270f85e53f289a8ecc927c88a19a070c6ea97a1793437c1"
    sha256 cellar: :any,                 arm64_sequoia: "197871f8de11dc8f1311726c1df7fc4c739f88c5a9352a742ee54a64d4117cfc"
    sha256 cellar: :any,                 arm64_sonoma:  "e53d28fcf341b55b1622c7c23b8e33d0e25d42b9803eb9730c53e07037a0cbef"
    sha256 cellar: :any,                 arm64_ventura: "3cbdbd014289232556ffd784dd8f9440349e5598e925aa28134f05feb45a5767"
    sha256 cellar: :any,                 sonoma:        "c43c199ecff386933bd3b069261aa6c0d08243e4f51008a475c89216f19b4578"
    sha256 cellar: :any,                 ventura:       "9bbc38300371f5d38a3151e7e08bb57e8298081f5e7193176d2f0c4a7daf49c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b72d2bbc6b70fc96f92a37a45b80be6218b47c42c22d772a9790694ce033165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa851ba5615a5bfe0c555334e2b03d64d3201c471852064227852dea8c8f44a0"
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
