class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.07.01.00.tar.gz"
  sha256 "833fc3421cb8a17ab1c2b5542e76074bcb9cfd534ec5e459393dd1e774921907"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e95ba454bff90b1e912387094cd2360aa875df317aa11b3c5a3a870776bc76b7"
    sha256 cellar: :any,                 arm64_ventura:  "bf904cfbcf0ab00225add25ab3fdf04be6e320d4cd6e142b218c54f19fe9237a"
    sha256 cellar: :any,                 arm64_monterey: "963783b8ee6e80452ac57eed6ef73687076cb7b29599d85be62b18a82d7ab5c4"
    sha256 cellar: :any,                 sonoma:         "c11d28004fd8e013c6fef31860d5842b514e32b22a183ca8a1a355b7408ad38c"
    sha256 cellar: :any,                 ventura:        "a1477e17eb46829c63847d497ccb1e009b0aca5afa9233c7abd14461e5258272"
    sha256 cellar: :any,                 monterey:       "4c3ff578d4390710716de16b367a0e560188ee775bbe345c459b75f46beeaaeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08abdf897368c5a3ac25fafec38612eef560a131584fd6a6e56627f445f4e520"
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
