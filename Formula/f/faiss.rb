class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://faiss.ai"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "7b583010cc3c0a778b909a1beecbc5a4bd42f415d82af734b2c05d5eaaca0ffa"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9df7e50e22a08e9b020b4d025b15505127fb828ff5b931381419dfe7bd7381cc"
    sha256 cellar: :any, arm64_tahoe:       "bd8a4ea7137baba4514d422a84093235006faae8738868743bb5a2024ff23078"
    sha256 cellar: :any, arm64_sequoia:     "6cdc984648e15ffb9dd628414530bb8839fc88d65b6b01fb4bf4d04cd17094d3"
    sha256 cellar: :any, arm64_linux:       "0a2086210cf972d88f9b77f68d44fb6c5d042ba09becdc3f530d17b6af1eee31"
    sha256 cellar: :any, x86_64_linux:      "3fd3a9166d24ec7860d6434899bd58d513a303d30102f3fd92665ca5fa6877d0"
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
