class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.0.tar.gz"
  sha256 "f86d346ac9f409ee30abe37e52f6cce366b7f60d3924d65719f40aa07ceb4bec"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "9a246c8f1cd335c9f9faba1a26b38cd6c91156ef25a2400e5ff0aa2d61042701" => :big_sur
    sha256 "457e410d8e5b009bf12cb1b5881485f03461646ef18ff8afb69dbbc7113519b4" => :catalina
    sha256 "b3eb242ff373017f8d7ba621fde32d745a6d7d6c5c7ca5de888b7f8087e94776" => :mojave
    sha256 "03b95260a4fdd6cceaa69bb4e7168939aadf2b608f998079f7511aec6171f2d1" => :high_sierra
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
