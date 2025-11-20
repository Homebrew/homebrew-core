class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "6db002fc020fb8d02adaafd06e1b3b8fb4f9301d25d18392e27eb6e63be0361b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d787d0f878735a54adb0a6d00608b8dea34f776088513f0344d449105a46a800"
    sha256 cellar: :any,                 arm64_sequoia: "dcb0612cf7e472fbfd57fb150fbb82d47a883feee0bbac87b0e34475bd9b680c"
    sha256 cellar: :any,                 arm64_sonoma:  "987a764fad438ad08376382339b8adea2258b6693d6d7d442ee5f12852b93963"
    sha256 cellar: :any,                 sonoma:        "b74e99f465f023f0dc0ca79e0c2427d81770a2303675f0e54bcac0e6f0539ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d0eda1b8a7cf2f00951e8eadf7352779721fb86fe0e2679115d12bb8c731c15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0776ba46c37eb1dc3b7f86ab5ac7795ae9836c2406cb6e11251a36b718cda0ce"
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
