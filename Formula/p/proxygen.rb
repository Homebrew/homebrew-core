class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2024.03.25.00/proxygen-v2024.03.25.00.tar.gz"
  sha256 "29e1ccc5c9cbd3b81b4e17bb4e781df31e6551f47ed8d28d90df8b5d8456d181"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c092359d457cfc7905ba9282e505b1ab90059e8d5c26e91e1a2cae9bdb786f93"
    sha256 cellar: :any,                 arm64_ventura:  "28dfe48611e7e9cd38a38d0b4a624c68f203e6fbe2ac72719132cdbe5ab7de2d"
    sha256 cellar: :any,                 arm64_monterey: "240003ef765c41d873c736a90136e0b90cff62a000e4ebb2f914481b545f1800"
    sha256 cellar: :any,                 sonoma:         "fdbf6d137360e8266277b388bf6fd5e57d302783a070618e8b91fdc7dc58513f"
    sha256 cellar: :any,                 ventura:        "2fba6db316dd6747025dc57adfc4e925e085c00eded632e621628d51c5122b8f"
    sha256 cellar: :any,                 monterey:       "07f8b137d5ad3674d0c4f20f87e9c8874cbe6ff747fdd23add9958cb26ecce2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51169417ebad127293a7d7da2f0a8a06d6f32e5aeda9eee4d972bc53f70cb12e"
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
