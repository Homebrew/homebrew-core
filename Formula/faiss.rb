class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.4.tar.gz"
  sha256 "d9a7b31bf7fd6eb32c10b7ea7ff918160eed5be04fe63bb7b4b4b5f2bbde01ad"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5167f0a3570add5d6225a09f8c18fd52d05758ad30bb7514abad3eb9beda998c"
    sha256 cellar: :any,                 arm64_monterey: "eb84bea51a9e7499ad00e35c598d91746de585867bc9eae4378d6cd7847ac037"
    sha256 cellar: :any,                 arm64_big_sur:  "72c4017de3970dcfc67bfd717d778073bb54ccebf3fbfc5ab012303243496ce8"
    sha256 cellar: :any,                 ventura:        "76cebd5782d9a687b9adc47b33c7b16b4aeb6ebcbf1f402f01ab48c12381fd7a"
    sha256 cellar: :any,                 monterey:       "af08ccd368572b567a065c796ff7c5dbe20cb44756897e3ed687f32c3d9ab205"
    sha256 cellar: :any,                 big_sur:        "e9a66b1a60606c2be470a304361cbd6bc557835d59e8ddffe0805b0e1e32b6f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "608f92f215332ddf3e6bee2a1476f261ed81f6ac1a78b7d1df53b33059ddbd2e"
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
