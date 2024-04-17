class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.04.15.00.tar.gz"
  sha256 "b195aa6fa2a62bf247a0aeb0d3ddfcb7b00d704997b233dc2892eb8cc1686f7c"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd5f61171030fe520d4349e237c39133e6ddb56d9dcc8aaef0949ad4073bffc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aa176e9c23b53c1a9a1c4940270f7fc8718654edeb831c5488ac4dbab4d6723"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9232e85f66e20bea3b2ece7196c9fa6bbb6dbde18e3267dae4e7f1495f7ddf9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a4d1caedfb3a288b415505d725a6495b0c9e95a99793a4e699665856c3ab91e"
    sha256 cellar: :any_skip_relocation, ventura:        "f2dbcaed03171441bacf13dd7c3ddbf53f3b920dd14dcbfc3da0c459a146676c"
    sha256 cellar: :any_skip_relocation, monterey:       "e323a2ca250af1ef2e218ca5aee12d329b1c49852c5b1d3220b33a989c22fb5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe00fe37a1f81fc0a70361043eac1c8d6d662bdb895043ea4435c23bc32e41b"
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
