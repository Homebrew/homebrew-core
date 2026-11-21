class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/meta/mvfst"
  url "https://github.com/meta/mvfst/archive/refs/tags/v2026.10.26.00.tar.gz"
  sha256 "7b2f2a84a5df3689d29a2c3c482b508e1d26251d568e9faf0ced22fb113e6dcd"
  license "MIT"
  compatibility_version 1
  head "https://github.com/meta/mvfst.git", branch: "main"

  bottle do
    rebuild 1
    manifest_sha256 "9fbb6016371560805511f9d09de2035e5403747e9225eddda4f93866ed40d9e4"
    sha256 cellar: :any, arm64_golden_gate: "bd98b59462a5905bfeaefe6d5f99a55d2b65fa2e58880b614f4a7889d3585425"
    sha256 cellar: :any, arm64_tahoe:       "69e86b696a843511cc075ff3be5ec539df4ecc521fb813120836e04848e3ecda"
    sha256 cellar: :any, arm64_sequoia:     "250f6bbd89ebdd853b0c4546212a3dbb4603d3271ce2bc8a22029e4ac8fa13c0"
    sha256 cellar: :any, arm64_linux:       "8af973b8ee1ea7894226a21eeab712f7dae3a4184b98a1807bb825520e5e18e8"
    sha256 cellar: :any, x86_64_linux:      "78252a240a6edd6c1173da72e09488a0b8775f46153cb2e0b3a6819e6a81d5b0"
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

    ENV.append_path "CMAKE_PREFIX_PATH", formula_opt_prefix("openssl@4")
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
