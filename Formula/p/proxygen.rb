class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.01.08.00/proxygen-v2024.01.08.00.tar.gz"
  sha256 "ceba9725a1b10a2d7d50bdadaa39a356e226b8d5ceb1f108ab6932baeedf57ae"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "162dd2c512d8a37e62f2971a96113c22ec3a80598e2d3d160b89f79fff75f085"
    sha256 cellar: :any,                 arm64_ventura:  "3e821d893f536249ffea5974f31294c6661abeb603aeca4de8902d7334567daf"
    sha256 cellar: :any,                 arm64_monterey: "91eaa6a38fe8f31ce422228a7b0b57d5c7f77d6363d613ed1c8feacefaffbded"
    sha256 cellar: :any,                 sonoma:         "0434b70be6c183ddfe961cd6e20fb73949494fcdc228ebd9f4aa9ac255f4452c"
    sha256 cellar: :any,                 ventura:        "feee4e02ccb23f6cde31d5d58834a3dc59f280a236e146e4c194fdb22411e648"
    sha256 cellar: :any,                 monterey:       "bfeb024ea50d046c977bc458331d397f4037b3dd8369dd81203b52fd3e003734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2fac1d5ebd71f4e13e95cd587f47699ce71df9d3ee676df701185244fcfa8f1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "wangle"
  depends_on "zstd"
  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pid = spawn bin/"proxygen_echo"
    sleep 5
    system "curl", "-v", "http://localhost:11000"
  ensure
    Process.kill "TERM", pid
  end
end
