class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.09.18.00.tar.gz"
  sha256 "14074bebc4f40a3c0369a79eaed362efe85f5fb86b81746a73db2331339891cf"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94a4c4dce35996bcbe556e410e75b20c23cfb8bf2f1db424f6473fbc70e939ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fce8506395a25f8f61e97fd3c2be34779fc438b8dfcd04d9d41d12d8dfdf60b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f05d577e231c30a52fab97864f56f74b74f069e6fa53dbd023b274649be54f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "378c38ba9c06997db9fa4560b58a20895c22c76aa12cd01ee3e66e84a6b3b198"
    sha256 cellar: :any_skip_relocation, sonoma:         "2645b75c59187ddcc8cb1fc282077aca29eae2f30c01f5bc47db02275721bc58"
    sha256 cellar: :any_skip_relocation, ventura:        "c54087c39791e5e7f1da029b89aa39d4fbd0695f1f410e39d1ec36e2ff6348a5"
    sha256 cellar: :any_skip_relocation, monterey:       "18471db21cb533abb849ffe50f6dd65c81f077a911cc2f664f8a5bbee33abe56"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc9650457442fe425f59f59177c9584bc49caec68a7d3dd872a47a0b9da5b3a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98d7a86f36d8ffdb5cb550e82c6bd57f4433563e388dae676eb9ce60e87fddd0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "boost"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 3.20)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 17)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quic/samples/echo/main.cpp
        quic/common/test/TestUtils.cpp
        quic/common/test/TestPacketBuilders.cpp
      )
      target_link_libraries(echo ${mvfst_LIBRARIES} fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    CMAKE

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."

    server_port = free_port
    server_pid = spawn "./echo", "--mode", "server",
                                 "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      "./echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr|
      stdin.write "Hello world!\n"
      Timeout.timeout(15) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    end
  ensure
    Process.kill "TERM", server_pid
  end
end
