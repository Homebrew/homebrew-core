class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2026.03.09.00.tar.gz"
  sha256 "0fbdf46b742a76f32ca2c2bfcd9c6e9246f8bf9bb6921dbef65e087253af8970"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34db75a461a70131665342a48f33e275b40b46bf22213c607d1c0bc767b04263"
    sha256 cellar: :any,                 arm64_sequoia: "f2bfd1155948ce31973913e8394c01cf2581eccffb6a58579eb4d70e9f76d992"
    sha256 cellar: :any,                 arm64_sonoma:  "6cf4c8ab66b9a94c96b92e98481de480eeae76fd14212833d212019a99ef4b26"
    sha256 cellar: :any,                 sonoma:        "19c0c92c69b9d0b89796704b69705333c49f59820e874e6dd8b5f3d564bdc331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4d9571e1502ab586d4c613df8ea33fdad7b9a0d44072b309190bf3547969b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9321b74ccb7b120cc305fb0ca489568aec75b49ad6b799fa653f3cfbeecdfb87"
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
