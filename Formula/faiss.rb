class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.2.tar.gz"
  sha256 "d49b4afd6a7a5b64f260a236ee9b2efb760edb08c33d5ea5610c2f078a5995ec"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e09e62b7668f4cc1899538f6f04d6a5ffc9c13754333fbd4a0c9dc31180ea34"
    sha256 cellar: :any,                 arm64_big_sur:  "2ca971705fca0cec23a32678b404051806fba19ac5d94b54f64313c0cb03ba09"
    sha256 cellar: :any,                 monterey:       "fba20949524dce97040f7480c82e96bd44290104c5205ada67ac50d23f85f8e4"
    sha256 cellar: :any,                 big_sur:        "560c0b69c9bdde354f76571e68f139449d25d51316efb46753c3715ee455be53"
    sha256 cellar: :any,                 catalina:       "4e1b90273c772316ac6e86f60b227eb2190c6d9d3c2b7aea9d080a566ff722d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c939a869e7804ba8f9e5dcbd7cbc555eb1c85d458efd40be703eea18c9ab1c2f"
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
    system ENV.cxx, "-std=c++11", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
