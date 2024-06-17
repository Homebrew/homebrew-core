class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.06.10.00.tar.gz"
  sha256 "cc75889429a66463cc8e607ba09d584fb4e6d2e69b1127a538043b367c54a1ae"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be4948a70ea561cd2668d2fd0b03901cbc39b0c7f97be0197eb581ddbfcea37a"
    sha256 cellar: :any,                 arm64_ventura:  "9a7a6a4267f1acae8a10e3249f59fd64b64ea6b95de74ec3a3cf827ea0613ff2"
    sha256 cellar: :any,                 arm64_monterey: "a089eccb1602966e8d20a927d1d422e1950e548e97731570a16f9579575374fd"
    sha256 cellar: :any,                 sonoma:         "e4e3fefcc348980921d219d9a6c086fa552e86f78b87d9c4e31e8f7293784f11"
    sha256 cellar: :any,                 ventura:        "e4a7e5c2fcda18f69b3b6c929b0eabcd63b901d6b7deb5916790dbe999a97e44"
    sha256 cellar: :any,                 monterey:       "da3c5a32e67a863c955630b8e850fca487155b368c4a4bb2418e3410a561493d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f7529e16f5abbc86cced50d243fd76fba8e6845740dce5e4cd57d8e1e053b4b"
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
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup" if OS.mac?
    system "cmake", "-S", ".", "-B", "_build",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    *shared_args, *std_cmake_args
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
