class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "18a1604867021641cb3bafcd9fbca4df944fd65e45747e186b69c7e7f72d0f3b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ea4c801a9adfe8f0808739579dc3c40324fcda29c107aecbdc40759b1d8adab0"
    sha256 cellar: :any,                 arm64_sonoma:  "23884ab573352bdd8604a436cf7d36bfea3a5a5e3407d39fc241c545fc58da68"
    sha256 cellar: :any,                 arm64_ventura: "5e4a9752316103e044097b208b702b979b68ce23e9f9508dceeee91afe775484"
    sha256 cellar: :any,                 sonoma:        "481d24a6506fe7b4265b4a1f97c72b36cfe27f62561ccf09052275687a0d21cd"
    sha256 cellar: :any,                 ventura:       "c78ac06fa01a566dc87c8f60b2b1a92c4993ccab17adfe2bb4a916e726fc39af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d414069d3aa7819fed98bf5f0d8908c47239fd0c870215e3323d8b2541d4951"
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
