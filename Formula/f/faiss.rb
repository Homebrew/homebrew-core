class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://faiss.ai"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.14.3.tar.gz"
  sha256 "7f3c4ed9aec3bd7524382862f5fcbd4d8984e2a8979ff3bdb2c0bcea5144149e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2fe9d0d0db7e4b0663db2501b4b479e4f0f9c24eb2bc4351d1842db01c46d0fa"
    sha256 cellar: :any, arm64_sequoia: "460a4415deb11f1c13427b49e9b34c32c61a04a14bc86a893eaba453e47f85c1"
    sha256 cellar: :any, arm64_sonoma:  "c887b8db3373111c3f91ea76008813978a878ba6af61d9e4f8defda88104f44b"
    sha256 cellar: :any, sonoma:        "b0f1d1d150e01e2726c7b662fa61697c809d2d6a6afc5150d8f05b8cf79da883"
    sha256 cellar: :any, arm64_linux:   "e0a91569d6c28fd854a149048cbe420a99311ac963323897be65f768e248fcf8"
    sha256 cellar: :any, x86_64_linux:  "f4572192265b641a8020be585854aac0dc6bdd3df0a364ccc40a387c6d38c7e5"
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
