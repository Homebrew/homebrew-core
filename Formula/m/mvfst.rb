class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.09.04.00.tar.gz"
  sha256 "15470fd5c9dbffa727caeb76bee415ebe55e4c1770cd215249fd8c27b88d1f66"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9690e90ae6e7d7b828cafe41604521d26d9076a8a0b3a1d06c6c16d7093fa360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "692d2035ff89ccfbeec8542c3724cc0243c7195b33d8d3e36b1285c4f42bafea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "895d2b70e446b901373ff07fdf9bf035a6d13116fedad1e2106d764f77471be9"
    sha256 cellar: :any_skip_relocation, ventura:        "e9eb010dfd4a686aea235f73c3923521f95867cf985be09f14e964a4c958ad45"
    sha256 cellar: :any_skip_relocation, monterey:       "9d2dbdde0cbbbaac207e2175622f8fa788a44db31af4d6e6c97e4fcc3198a1c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5032b673ee07a0f14ee4386a4365970ba186025df55d93913b87f15d3ea60098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6bdc3948c24312911618584812d113182c5b77c3af4762c889ca54dcea018f"
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
