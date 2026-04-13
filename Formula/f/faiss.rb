class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "fa61ba99973fc3f5cd8f54b112b02d9be162bf29c6cc7c393604cda2d11e0446"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f9f8ae843b91c46fba4ae7ac8f5e863721099aa7db6c84ef9ac5840f69e43a7c"
    sha256 cellar: :any,                 arm64_sequoia: "7e6f2343b410ba2648a3d8cf5ddb5019906cf335bb98670b585d0f9e2c03b282"
    sha256 cellar: :any,                 arm64_sonoma:  "8c31b9cc01b4e4f349700bdf89fda46bf08fd1350a2d05f0b43ad80f3b6b9328"
    sha256 cellar: :any,                 sonoma:        "dc01d70a4338c134bf51277cc3e23e3e721224fe36c8b67e7b4b6f6294edcc0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca531cb4ccab1ce090f96146d862af48057f1110a827230bb0e71d1c7241b2eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a789aa1e023671b4c02894871f5a4c63f7886e8586cdabf60b4f0f792751ec75"
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
