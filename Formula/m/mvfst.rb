class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2026.07.27.00.tar.gz"
  sha256 "7e3b85c6dcbb96804936883eca2b429bc17ac9a74e5a86dfae5f919701bf12a5"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "62e31ebe6aa72e7361d27b15f11acf51e5c6d8933021ce26d5bc73b402d76b01"
    sha256 cellar: :any, arm64_sequoia: "b377758a2e1a1d855ac6b43cba00983c4eebf4f78e9ec1a2e815ac89d7dd1eac"
    sha256 cellar: :any, arm64_sonoma:  "190215cd0304f5abc99ec91ecea28e6fbd6bb71a3b2301f58df30ffe67dd0698"
    sha256 cellar: :any, sonoma:        "df50c840d961c0f093e5df52cf345c087415023df4e9a9ed6ee877932f69c352"
    sha256 cellar: :any, arm64_linux:   "c6d61739c645e4f34c580dc064fff7199a473c73b94033c00c8c4ec71ea840c5"
    sha256 cellar: :any, x86_64_linux:  "21be84a5cc6cc72274266372367be19e6c0b5d1138b55538a21fed551d26f24c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@3"

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-undefined,dynamic_lookup -Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "_build", "-DBUILD_TESTS=OFF", *shared_args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    ENV.delete "CPATH"
    stable.stage testpath

    (testpath/"CMakeLists.txt").atomic_write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(echo CXX)
      set(CMAKE_CXX_STANDARD 20)

      list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
      find_package(fizz REQUIRED)
      find_package(gflags REQUIRED)
      find_package(GTest REQUIRED)
      find_package(mvfst REQUIRED)

      add_executable(echo
        quic/samples/echo/main.cpp
        quic/common/test/TestUtils.cpp
        quic/common/test/TestPacketBuilders.cpp
        quic/common/test/TestTransportUtils.cpp
      )
      target_link_libraries(echo mvfst::mvfst fizz::fizz_test_support GTest::gmock)
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
      set_target_properties(echo PROPERTIES BUILD_RPATH "#{lib};#{HOMEBREW_PREFIX}/lib")
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    server_port = free_port
    server_pid = spawn "./build/echo", "--mode", "server",
                                       "--host", "127.0.0.1", "--port", server_port.to_s
    sleep 5

    Open3.popen3(
      "./build/echo", "--mode", "client",
                "--host", "127.0.0.1", "--port", server_port.to_s
    ) do |stdin, _, stderr, w|
      stdin.write "Hello world!\n"
      Timeout.timeout(60) do
        stderr.each do |line|
          break if line.include? "Client received data=echo Hello world!"
        end
      end
      stdin.close
    ensure
      Process.kill "TERM", w.pid
    end
  ensure
    Process.kill "TERM", server_pid
  end
end
