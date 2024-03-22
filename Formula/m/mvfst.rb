class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "7f42ad4b8da5646a24ba5e96101da914f77fe581abd686568d1dcd6492df0240"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0123d215543ace1f10c7ed22479cb0eb24eb94dba8c388ce11bd174b37089caa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0662ba619371e6a0848be6af134ca9cb8377fc94c54a210d93d3ff339761485f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21b08fd57d688dcce6b88aa87359118d5fc06161f7f493f9615a091a0447dca7"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b79a17ef4d7bb8202d23382349aee6533a728e87a12b015eebccd5261e835d1"
    sha256 cellar: :any_skip_relocation, ventura:        "951fdc0eaf3f70a811c329b2bc250eb6a768befd37a60a0fa16170341e583fbf"
    sha256 cellar: :any_skip_relocation, monterey:       "1daf759e385f14dc3728002de8a3b9f5d7b53c1a2472ce786bcf8292628d91d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfe7c440a853d38bf256ee72f007ee5244e73da82b6a0bf259bcfbf46ddcb796"
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
