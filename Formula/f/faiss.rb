class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "a2c0f71236a095e6158aa3738652b16dc3dae1db22c5dd8fb07fc1600e870694"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "837465ea6d0be687254d8c73d2b2e827bbb3164e4ca2683fe50e519398f5a6ba"
    sha256 cellar: :any,                 arm64_sequoia: "068e17cf36c9b6f59d88f54cd61e7dcae82ad5e3df06f04c96d778046ff440f6"
    sha256 cellar: :any,                 arm64_sonoma:  "7478067057353e4549c9513d0e85df79ab2b4d4e9af4865ca1cb2e1113c6d16f"
    sha256 cellar: :any,                 sonoma:        "22ea174e90b8effd237c6d52f81836e32c756e9d8a35032b8e6cdd2301b7feae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2ff5e15fbc7be668b488c3f947bccc1029196d1b173dd4f970dc915807e877f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac0ed6fa66fe5aaccfafd9f11c42666862eb80db3e5383eb06fe10bb88485a03"
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
