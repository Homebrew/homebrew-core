class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.01.08.00.tar.gz"
  sha256 "cd479fa95041e436f012aae2402b82d62534ac43df72b4e41d47f2ca67092a02"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64d53d5031e9fc2fbac74decefa11932642246bc4a738310cdabeda258d86e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49c11f06f492c2965204728b8e44aa6e753d042c70755a1d2173f455dc471822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f0bafb1da5f726a4c4c9dbfb38c633ab81d744034218ec86b5f8fd51d5dba78"
    sha256 cellar: :any_skip_relocation, sonoma:         "741d34c57a2777f659abfc50b73675e34d45a6c843ea6700ea932825106e6ffd"
    sha256 cellar: :any_skip_relocation, ventura:        "96d166054715f60f2f91e8fe030d5ebc74cec42a3f2cf9be0f7ebe4aa44b5913"
    sha256 cellar: :any_skip_relocation, monterey:       "1c1338e2ddb5e90b2c119f3f34d2e91c0c97a45ad9f68c5e5654f8711b709eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931261419d8e1adbd9971f333553454680d8690a063873a65be0566c06ded988"
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
