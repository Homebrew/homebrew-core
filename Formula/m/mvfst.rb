class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2024.10.07.00.tar.gz"
  sha256 "5609061c376e37378c1a05ec80ed07924d7e2732a8f02ba7b5b2272735f58374"
  license "MIT"
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "20a03242b5175d2d1e97bb5bf21d1b70ed0337ffb68a7a2f18774bcaf8548b1a"
    sha256 cellar: :any,                 arm64_sonoma:  "dcdf0971a7f21ef014cd1eecbe97dca35f38bde5d85badc168daf20b8b62033f"
    sha256 cellar: :any,                 arm64_ventura: "ddfbc740098486d047b715145173377a4a37260d2d8809fcea077f1f1c955416"
    sha256 cellar: :any,                 sonoma:        "98f6ec13588cd5fa031b3041c0be1e48364863687edd5c910235ea4ec5759cd0"
    sha256 cellar: :any,                 ventura:       "b3167a4c54baac0a17a68e1f55a35fa210e4d34577f3b5e41da36cc091ae8c89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "affa06c9040070bd52d285186ee368ab3d181c56ce7809f236be4cf421a6eb59"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "googletest" => :test
  depends_on "double-conversion"
  depends_on "fizz"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libsodium"
  depends_on "openssl@3"

  # Fix missing symbols. CMake version of:
  # https://github.com/facebook/mvfst/commit/0b2743fdae9b746659815afdf00611fe7999282e
  # https://github.com/facebook/mvfst/commit/654c5b90d2e9431e71f0dd3d5be990200306acc4
  # Upstreamed at: https://github.com/facebook/mvfst/pull/354
  patch :DATA

  def install
    shared_args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    linker_flags = %w[-undefined dynamic_lookup -dead_strip_dylibs]
    linker_flags << "-ld_classic" if OS.mac? && MacOS.version == :ventura
    shared_args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,#{linker_flags.join(",")}" if OS.mac?

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

__END__
diff --git a/quic/api/CMakeLists.txt b/quic/api/CMakeLists.txt
index 5522347c5..a0a34761e 100644
--- a/quic/api/CMakeLists.txt
+++ b/quic/api/CMakeLists.txt
@@ -47,6 +47,7 @@ add_library(
   QuicPacketScheduler.cpp
   QuicStreamAsyncTransport.cpp
   QuicTransportBase.cpp
+  QuicTransportBaseLite.cpp
   QuicTransportFunctions.cpp
 )
 
diff --git a/quic/state/CMakeLists.txt b/quic/state/CMakeLists.txt
index 0916546fe..14297bb30 100644
--- a/quic/state/CMakeLists.txt
+++ b/quic/state/CMakeLists.txt
@@ -55,6 +55,7 @@ add_library(
   mvfst_state_ack_handler
   AckEvent.cpp
   AckHandlers.cpp
+  AckedPacketIterator.cpp
 )
 
 set_property(TARGET mvfst_state_ack_handler PROPERTY VERSION ${PACKAGE_VERSION})
