class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.03.18.00.tar.gz"
  sha256 "7f42ad4b8da5646a24ba5e96101da914f77fe581abd686568d1dcd6492df0240"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4590210f9d58e7af94a5dffb1fd90a8cbf18f013156116d7558cc6d849cc28e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af34bef03ed5100e6d6e8b427b2d2e6b3d213b6043bec288b20909e42780c138"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee92bc2e355b7e37561d47f1bbb73f9fd0f94a68a1212bf6bb0ce7f3fc4cfcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1fd610fdbc8baf53b565f2d128c44ea12b20a99b3cb142d15969495a4fcae3e"
    sha256 cellar: :any_skip_relocation, ventura:        "b783d529e644bf9ef44ef1358ce239573b34a7641e6ae0c50bccc749fe4aeac9"
    sha256 cellar: :any_skip_relocation, monterey:       "1f366b10209640735fb64809f4ce2c4e7987a1ba3b7607a119cf338a63578b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f47bc0d28f5df4660096f42847bd23931d5d46eae5127119ca97521e9a7375b"
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
