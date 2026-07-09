class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.5.2/manifold-3.5.2.tar.gz"
  sha256 "ce5f4d87877daca99a910d0af73c028f2a36b9288dd2bf3cd1cecf8faff9f7c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "97f2f54cdcf1c6c6daa46a85a09b656637b9b482db7e1eb022590afbf30c1352"
    sha256 cellar: :any, arm64_sequoia: "76e8797ff294edc0a00b42023ba57471a65427cd360c3b5cd38eaa18028a3988"
    sha256 cellar: :any, arm64_sonoma:  "decc0db1b57f6e7e47c0acf6fe1d25fc8953ca54ac4b8fb1f5c710ce1040b92a"
    sha256 cellar: :any, sonoma:        "db85c2d71b21e800244c993d1c446dbb244b998d0324a3e2989d29454c539137"
    sha256 cellar: :any, arm64_linux:   "fdffe58a01bae0ddcb2347b18a2bbb4f41167047b4650fb864e498cb1ee6d14b"
    sha256 cellar: :any, x86_64_linux:  "4c9a4e13614861e1005501b178a00c0f8a37ea3bb45870a084f182ed7948847d"
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
