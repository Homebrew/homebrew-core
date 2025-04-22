class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "65b5493d6b8cb992f104677cab255a9b71ef1e1d2ea3b1500dc995c68b429949"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2bb622b747d36f69a21edaaab34b1874fe497111576d99619aa08846ddbcadb4"
    sha256 cellar: :any,                 arm64_sonoma:  "c235f84427a5f1576cfb21d3538aa838c9242d0c655ab3ce60fb1aee33374d7e"
    sha256 cellar: :any,                 arm64_ventura: "6ba791214c0285485725e09a62007e049e53797f3987afb356855e1ddcdf664e"
    sha256 cellar: :any,                 sonoma:        "713c401369b088c8030df5205237b19c58e1fa2540ffe3f3f8a1e096379e2a7e"
    sha256 cellar: :any,                 ventura:       "93b405f414c4020646204b7ec71f73192e61ac1e2f9b48631765e8b848232f86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8113470463e906951448f418eac827c6f128c586d86730442b4e9ef9a82df9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c3e64ff3daaf77a1e80de4bb96fbb9d5d9a4eeb04686dffcd087ba175363a57"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = *std_cmake_args + %w[
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
      -DFAISS_ENABLE_C_API=ON
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args
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
