class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/meta/mvfst"
  url "https://github.com/meta/mvfst/archive/refs/tags/v2026.11.23.00.tar.gz"
  sha256 "1990ea9839c72b15ec33aef42cf2cdb89ffb6d4a153cef1d85d020e3f6d48dd6"
  license "MIT"
  compatibility_version 1
  head "https://github.com/meta/mvfst.git", branch: "main"

  bottle do
    manifest_sha256 "3c6c024b85acec853cf6a5aefdfaa5ff07c414242cf2dda2f2a8e3261745bbca"
    sha256 cellar: :any, arm64_golden_gate: "ce8fc6b20fea01a7cb7a4ed66eba5e22b1ed292c8634c20f82d655edb132efc9"
    sha256 cellar: :any, arm64_tahoe:       "6e97e7c626f2b50c5a37c4a51d0a4d9901e231197f6b6d6adbd83091fbd5e60b"
    sha256 cellar: :any, arm64_sequoia:     "53e2851843d068ba44dcaf95a1dec292c8d3c7450bf60b2d75cc223e17294556"
    sha256 cellar: :any, arm64_linux:       "6aa05ef58c131baab3981348418ecc7f3dc3570580d2ff69e9be980097b93f2e"
    sha256 cellar: :any, x86_64_linux:      "c05b1a55151e0edccf40e80261de732e4b193d69ea332eb8a38ec9d86bee54c0"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl@4"

  allow_network_access! :test

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
      target_include_directories(echo PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${OPENSSL_INCLUDE_DIR})
      set_target_properties(echo PROPERTIES BUILD_RPATH "#{lib};#{HOMEBREW_PREFIX}/lib")
    CMAKE

    ENV.append_path "CMAKE_PREFIX_PATH", dep("openssl").opt_prefix
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
