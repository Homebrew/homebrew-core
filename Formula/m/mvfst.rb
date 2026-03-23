class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2026.03.16.00.tar.gz"
  sha256 "4095de8db4108cec9351aed2df202e0353175687ad3235bf254c06e92ccab50f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c5f1ff49d470d2c961df62424b1d1ad99279d9fcc43cc380b6b6d56f2c89f87"
    sha256 cellar: :any,                 arm64_sequoia: "bfa14d85946f0ef632650c2c91c20296a1c6716448393593db73f39d106434c2"
    sha256 cellar: :any,                 arm64_sonoma:  "5422183a3f67d44f37e4327ab5ec4bc07e82ccca0312f37ac853b4ebec3747b9"
    sha256 cellar: :any,                 sonoma:        "88ec2c9ce9ca938654a62197ec283800dfaf59e34414ebfb171814e95cabce4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8180b0f99ade9c6fe4c82411c06ffc52ca0345871e02047d4ef209b8cbc38ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d8ae4639c170da3a24420408dcbb2ba24d8a5a655adbd3e9b43c476a1c2d14f"
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
