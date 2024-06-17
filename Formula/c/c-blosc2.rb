class CBlosc2 < Formula
  desc "Fast, compressed, persistent binary data store library for C"
  homepage "https://www.blosc.org"
  url "https://github.com/Blosc/c-blosc2/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "b5533c79aacc9ac152c80760ed1295a6608938780c3e1eecd7e53ea72ad986b0"
  license "BSD-3-Clause"
  head "https://github.com/Blosc/c-blosc2.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0d92e3db900d067354333a56feb6dab51bb95e8e0c6e6438804e93350d9739e5"
    sha256 cellar: :any,                 arm64_ventura:  "ebd660b0ba511b0b73b7d811e57eb55872b8c7aa43b7b0dd91d9e4dfa2f732d5"
    sha256 cellar: :any,                 arm64_monterey: "e1726999e8ae8624538f8126afee27ef49544e023e97c2f2c3e04b009fea8048"
    sha256 cellar: :any,                 sonoma:         "7f274d1e7937e069bdc9f896c96f33adfc646edc6c2af748bfebb942a9c06a2b"
    sha256 cellar: :any,                 ventura:        "11620937d20627f8078f73acfcc053d2fefef60d539bce2ab23267f1273b25c0"
    sha256 cellar: :any,                 monterey:       "d4437295b53fef0c819b690bddc8b53b5f3d06268a748ac4eeca1fd923a2454a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b038fb594a9d05c5a57174a33711016d5ef162f224fd7f78beee69e982d267"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "zstd"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1400
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1400

    args = %w[
      -DPREFER_EXTERNAL_LZ4=ON
      -DPREFER_EXTERNAL_ZLIB=ON
      -DPREFER_EXTERNAL_ZSTD=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/simple.c"
  end

  test do
    system ENV.cc, pkgshare/"simple.c", "-I#{include}", "-L#{lib}", "-lblosc2", "-o", "test"
    assert_match "Successful roundtrip!", shell_output(testpath/"test")
  end
end
