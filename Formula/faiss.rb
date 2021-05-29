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
    sha256 cellar: :any, big_sur:  "89ec9edffccfa90801a31fea3d5339b7e3c772a0184d950fb26b6ee8d10e0d5b"
    sha256 cellar: :any, catalina: "12b6e1ba976aadc8b04cc0f6be7fa258e9b02d8fefe48abcc4ec0c2a413c819a"
    sha256 cellar: :any, mojave:   "599117b399279c6a0030fa2c13f74fec22dd777c1c1f68eaa17b0055748d7ebe"
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
