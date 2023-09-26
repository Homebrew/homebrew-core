class Proxygen < Formula
  desc "Collection of C++ HTTP libraries"
  homepage "https://github.com/facebook/proxygen"
  url "https://github.com/facebook/proxygen/releases/download/v2023.09.25.00/proxygen-v2023.09.25.00.tar.gz"
  sha256 "7a0d9f048c1d8b0ffbf59ab401fe6970a39e88bf6293cf5c296e9eab4ca2a69e"
  license "BSD-3-Clause"
  head "https://github.com/facebook/proxygen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a119242adeb58d1f7be87197937ef4a6afe23c8d92457b7f2bcbb0568dd0d937"
    sha256 cellar: :any,                 arm64_monterey: "19fd3dbc3be2cb8138486d50fa9ef72cf346fbf82fdbfbd890f37bc9d93626cf"
    sha256 cellar: :any,                 arm64_big_sur:  "3c1c720cd27f9cf3fbde369cf90922376fd1582770ac574cebde012dd4698990"
    sha256 cellar: :any,                 ventura:        "089d1586683128d15776e9a0c8e05f3ed7f24cfa61259f8f1fde679d30892eb6"
    sha256 cellar: :any,                 monterey:       "1b73b5d8ce8f68854e06e684f1a257e2cb6417a0ff4834c9a424e0d7e0ec89d1"
    sha256 cellar: :any,                 big_sur:        "cff17fef29debe312082af94a15f42b869b141c5a7b2751565706d6e5735e242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "594c7b537a70c796b14a9e941a8883cd97c252391a6927e5b78068fcc643a968"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "mvfst"
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
