class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "9a81835c98627f2225b55ca85402262b57956878717ec1bf8858033b9f7d1255"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "98d7793b8db89eaccec26754b9b971cfe3ee15418a8683c98f803042211b3008"
    sha256 cellar: :any,                 arm64_sequoia: "8a6f9dc760079f6497d435f369a674625cf727c0cd16c39f6b7811b56cfcc8ab"
    sha256 cellar: :any,                 arm64_sonoma:  "5846bbf3335fdb0a4ccb4347e72c9021b6df06bef21d4f1f299be7864e45b3ec"
    sha256 cellar: :any,                 sonoma:        "5712c86281af7c291cdca73928fd56a9e90bb234d1555d9ee5d666ef3cbabd4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d068c22e09778275a525025bb4a4b74d35b2ca8b6a159d18523dbcb152e5e32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06cee15f495c22ceb60e6fd8d967584a39c8b892cee3a55837ecede754a902e"
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
