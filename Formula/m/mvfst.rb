class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.05.06.00.tar.gz"
  sha256 "9bfbdf7a73fdaf2e135050a9efccec577be1590e8ecbb262543a78fea14424b5"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6664673ce4489067a745c4c67e8a0b91c22f2f5fdec226a550f8186456cafc19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb89e4e9a8ef6e8f8edfb2be8e53b7ebe69218b55235e4986a877dbb32298a17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4f4416d05b1506e76cdd7d03bbf86bad1d29640ec214d095ba267c3df6319af"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8af3398fe22f18ac092aa60e08c1886a3e36dae83a0f79c9ea13a2c41fdf7f2"
    sha256 cellar: :any_skip_relocation, ventura:        "cfea0da503679e5ddfea4c81d2c6b71977b4a1bc1c21f8dafe5d0d73b8b79729"
    sha256 cellar: :any_skip_relocation, monterey:       "03dc69b82f312ad00241e7048fc44b7ebe9520fe305a3ce68771a21f4b4a38f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1681209b2c1c222fae5b83ba9efbdadddc1e152a68e23ba4307b409d7bd1308"
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
