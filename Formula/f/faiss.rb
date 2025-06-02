class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c5d517da6deb6a6d74290d7145331fc7474426025e2d826fa4a6d40670f4493c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d3210994d4d5947e4f9ff409008017041bb78c63da8bbb8c33982fac0436088"
    sha256 cellar: :any,                 arm64_sonoma:  "e1eed331775f15d07839202f5afde29c02dae475f69b0b1ce3e9c2a56f620033"
    sha256 cellar: :any,                 arm64_ventura: "0e7e88fa9223791ad67a1796b848c494f31b2cad1098dc38b2708153d3b27ad9"
    sha256 cellar: :any,                 sonoma:        "00a6a7d2ad3b6a910460195ba26dce73c28a6a04b9eceb969c1105beac79d378"
    sha256 cellar: :any,                 ventura:       "0efcad26bfb34e01e30b0cafae9c42cddb5ed2d64d997d321d355ffab4bf6ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6349970ff91a3bbc8ebd15e6287ad4f735fe5b4dcb91fb5f953c7ef0e19ce2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8577e0dae2c033bb0526e82dc05d72e49859432f91c43d7bb18bba4f3385b056"
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
    system ENV.cxx, "-std=c++11", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
