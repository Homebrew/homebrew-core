class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://faiss.ai"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "0b94bf4b17229b28a8a6686d7637ce93de4ef25f6308040184675befad9d9332"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3129c9328ac3acc6ae33f8ea4b75664bcc2a5f7f3dbf49d24448a33262140f8"
    sha256 cellar: :any, arm64_sequoia: "59c34003b7bdc97dcc638f77c0a2cee986ae213401dc1c151cfe943398a4640b"
    sha256 cellar: :any, arm64_sonoma:  "4e9329e25a667101321c82de634fe2bed82b23d000bfa9e6a0e9d267b1bd65b4"
    sha256 cellar: :any, sonoma:        "3f982cafc35b059c70e5fcdc3509783f10b824ddac5cfd0611e38dfd6c7a2129"
    sha256 cellar: :any, arm64_linux:   "ce669c56b43f1f48258debd8db683088e39b8f2f06f6159cc3ab7f5b89aabc5d"
    sha256 cellar: :any, x86_64_linux:  "c942810f55d6d847b3666dcd6a1c2a5643fbf345b1f3f95c10714b9f29da3404"
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
