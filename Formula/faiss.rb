class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.1.tar.gz"
  sha256 "d676d3107ad41203a49e0afda2630519299dc8666f8d23322cbe1eac0c431871"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6c6e739ef44832c1d17f1d3bd330dde1a8f1c68ca691362061f48672d0081fa7"
    sha256 cellar: :any, monterey:      "d95cf0e5c01bb7b748e79f95c5aff23c3f4a738cc70b6e7fc1e70ed832843c0e"
    sha256 cellar: :any, big_sur:       "ca98be5aa73a7f48fb1e22bcae35687f0503a76f1ff00be7d56c88e0dcf6f111"
    sha256 cellar: :any, catalina:      "d0ec19a749f8bf7a5a48cb828d7f6f1b7da9dff457d47c83b4a34cfedfb6d58a"
    sha256 cellar: :any, mojave:        "a719758b2de8c7489bdcbd795b2d1c81780c82a191c3baf2477c71fb38c8ff2f"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "openblas"

  def install
    args = *std_cmake_args + %w[
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-B", "build", ".", *args
    cd "build" do
      system "make"
      system "make", "install"
    end
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lfaiss", "demo_imi_flat.cpp", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
