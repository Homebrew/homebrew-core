class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://faiss.ai"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "4bef4f97e7e0a88c150f6c85897bdda411dd875522e7bf601ad27dfe6f55179d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a1cfb896b5eadd5c8f4453339e42649a42946598d0ecb90a6632ef9a1071f302"
    sha256 cellar: :any, arm64_tahoe:       "9e6e84783b6be6742c0445dfc97f7680deeed11a85cf116c8e7369f7dbdfba55"
    sha256 cellar: :any, arm64_sequoia:     "3062b6003bb9e74a6d10a15f6cf49943763d002b48e0737f8155f11fc5542af5"
    sha256 cellar: :any, arm64_linux:       "ff2af9538e5221cf358c526148238e848fb5dc80751f5392d54e4cae2de15ea4"
    sha256 cellar: :any, x86_64_linux:      "616079c93cf8e98f0205ed88a04f0912f9c9ed61d6ae38766d6338b8c2c9614e"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFAISS_ENABLE_C_API=ON
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++17", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
