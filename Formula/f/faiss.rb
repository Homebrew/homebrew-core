class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "561376d1a44771bf1230fabeef9c81643468009b45a585382cf38d3a7a94990a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d89a8709860e98acbfbb716ae6715a3fc232b102d85113741c4c2d0cd44b9bb5"
    sha256 cellar: :any,                 arm64_sequoia: "3c564c210de8128af0dc4a016277e846277395d9acc0051582931ae78a385315"
    sha256 cellar: :any,                 arm64_sonoma:  "310d97a638f6f9cf838a4786f255a187dcb5547cdb9c6cf4d1a1e5daae086ece"
    sha256 cellar: :any,                 arm64_ventura: "ea0b4cb763e453695ba67eb9ead7cfc1dace62b17987d2380bfba363fe66dd54"
    sha256 cellar: :any,                 sonoma:        "bd332b0c966b40480b2e31d403c61f506d5869c44fe757429c2545cc6166aba5"
    sha256 cellar: :any,                 ventura:       "73527c8cd2e52c74f972b1f1ae556be41b32469030106e07f78591a6e86d6d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "145f84010379e5cf39515890eee772e1053e22d0bd7c2a93e7cd1875c5020a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c5a32eb14b7ac73d388e4c9944109085fdf904e4b6a3157f95602e54e2a373"
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
