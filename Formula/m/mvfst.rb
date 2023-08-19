class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2023.08.14.00.tar.gz"
  sha256 "9d483056d80134237fe4ab2db6b5cb84515cead43bc455c5cd4b41a606991232"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "887288e1134a19ae17d1a4f9360037316ba72969229c23a7bb586b423725c3b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "147c3c10f54be976f98506b45fb08a7eaaf27796edb905c31fa1b19d212e3cdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdba2daa48c1913ece1ffd569fcd21b0101eb49f1a0a2228b3000f24e42e1eda"
    sha256 cellar: :any_skip_relocation, ventura:        "b740ced365bedf5d7a34a6b74e88de779fb60fda13d170e4acbb1ae7323ae660"
    sha256 cellar: :any_skip_relocation, monterey:       "772711d8775ce0bc75fc237179f135ac560eaa4362717c43f3b142a58c8a1a3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf79dd9bd22d220a274b4ce86578dc3ad28d415d34d39904da241c5d5eef3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56ac843116bc859c1420674cdd38424edf7b6f360dbf1460d2e1186f69a9cf62"
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
