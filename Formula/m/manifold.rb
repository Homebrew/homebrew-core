class Manifold < Formula
  desc "Geometry library for topological robustness"
  homepage "https://github.com/elalish/manifold"
  url "https://github.com/elalish/manifold/releases/download/v3.4.1/manifold-3.4.1.tar.gz"
  sha256 "c0283695648886df3a0ab35ead473622338782a05a247664925eb3c41ced0181"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa1b6aaf8f53281c221c85243a4857958878b5c438cf394e1f9148bde3c95dbc"
    sha256 cellar: :any,                 arm64_sequoia: "bd78a4a16e4367941bab70bf3b838ee256235ef3f241f704b05f10f0af24821a"
    sha256 cellar: :any,                 arm64_sonoma:  "523b788337489adc047b5a754a1863bb1095383c3ddea2970bcad1f3b6cf3e13"
    sha256 cellar: :any,                 sonoma:        "69af5b7f329fd5921321da5d0711c01a80fb2c4591111dc5d3937763e58cab00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ca61fbcfb6a53c3ba4ec5f3d7c8deed9c2787abe870f8e38b2946ddae75f5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79739a087311fa1e90f161f8bcfb53fe2eae82a13fced9e4db37a5d5cc970d14"
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
