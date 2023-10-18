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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9ee51131776348cac02bd190dae812d63896b8d8a374a20a72608eb18d670d01"
    sha256 cellar: :any,                 arm64_ventura:  "fce50696b90d0357b420807c89f13b20851a187759c01a20cec3cd281c34fbd6"
    sha256 cellar: :any,                 arm64_monterey: "d8e5da0af54d584559f730e823abfe76334638e86a6f58ffa8416efae1b58f8b"
    sha256 cellar: :any,                 arm64_big_sur:  "3bad3d3ecc1fa8fd4d8e6421f4bd2d031143490785ac3f276a432df9dfbd0ac1"
    sha256 cellar: :any,                 sonoma:         "5347a09cd113db4654eaeb277745edb5210277ab7e4203d2a72808a697769b07"
    sha256 cellar: :any,                 ventura:        "b6d728b6141c74eae30ae89c2ed3faa44a198afd890da6482b407209c79325c5"
    sha256 cellar: :any,                 monterey:       "8b88769ab126f91fd0269306e3bcc5102baaab9e61730095a24d71c5b3b79546"
    sha256 cellar: :any,                 big_sur:        "efc062d04573dd6d5b1911cc7cb333f125ae67aae11a8964490852297d8cf941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa475e6a354bfa4456b3f53537a649c68e3b672f4abf87e879d9a25a4215452"
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
