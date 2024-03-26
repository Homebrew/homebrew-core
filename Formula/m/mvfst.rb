class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.03.25.00.tar.gz"
  sha256 "293046511fb9395bdb09860f4c4202bcb848fed4cdd419d436506a07eeac66cd"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a203454de5d9dc9040b0c688f2da30a5faf3b73447c765f60299f92a0079a8e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8cc3dcc5989f0c35fd3e50e236ad2328526d58a5668e712138a67663a338f30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4d0aac9e602b1774903aaa7d32f917d52d2072bb53b1d6650451dc717e1ad12"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b5267eaf35caa45a7a7c0a933918f0799d93d78ed09c0be535dbc1b7fed4bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "af92f51cb1def14c54a80a62c5d92ef4c3c5cc234e0429ea5160d93443b079f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e43c570884e536f75bc378709a9712d6b797ee5db31de7d2d966b38b72a76f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e8ce104b369c2642aea44f7a867b4ea8bf12aaf896d1fc1535249c0b489d84b"
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
