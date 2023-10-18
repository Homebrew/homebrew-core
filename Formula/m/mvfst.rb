class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.10.09.00.tar.gz"
  sha256 "de7b8b39de14bc6ef527c9501460ff1adfb85adde147ee362a7e92a0ac3969a5"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "902b117a98cb2d9f01dd7adf4371b7078cc8c424d46fc459ae6050ba6ccf580e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce8a1cc7678825fcea1b36d07dc8c0321f74e091ea028acae40bd913cb2d9bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21d5a57dc6ec977d4d4c5430158d38067bfb5e6e2e16ec1b3aaf8bd1fcc622cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "73d2142ce00d9305a9d8845f689d62d6097fc25e68bb4b5ae6bf71c7e065f273"
    sha256 cellar: :any_skip_relocation, ventura:        "b7eeaa23d8dcd3fa4446430ba8d7b073c0fddd1bd6e876dbafa070d07cfd452b"
    sha256 cellar: :any_skip_relocation, monterey:       "e9427b1e4502f31bc380801b15c8e020783d7f2bf85bbc270c138f7b69ab9524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "696b995c35d2b090c2393803ce96ec166aa3c121f6524ff49a4392ff179b46ec"
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
