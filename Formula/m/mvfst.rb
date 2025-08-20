class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebook/mvfst"
  url "https://github.com/facebook/mvfst/archive/refs/tags/v2025.08.11.00.tar.gz"
  sha256 "9d475c425e658e7d2d55911856b47acf6c5cde9bf64ee4d9b380b1363a4c2f8b"
  license "MIT"
  revision 1
  head "https://github.com/facebook/mvfst.git", branch: "main"

  bottle do
    sha256                               arm64_sequoia: "f0df0dfecbbc2335d0b07f1e0e834ef411457dbac241639cf4575ffb5c82c8d7"
    sha256                               arm64_sonoma:  "bd5e8c3f80f5776022fa840aea36d9bdd636b7ed870252336303ccfeddc88166"
    sha256                               arm64_ventura: "ef8d632fcfcbb70aefd544291e46b5b42b2d978570bb24d3df130ed11f29a325"
    sha256 cellar: :any,                 sonoma:        "ba0f31b9248484925aa1c14fe8a4eff11cec4266c348af82927356c7ec548262"
    sha256 cellar: :any,                 ventura:       "08a1cdc0fe81f417987578a32a8a5934b3c7c7ce153208cd86dd041db3255c48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64bd2b6e2168e4df088e2f25284aebe09cc464e0bcb887aa7bbf38384806a8f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff6a248d5f8f8f1aa87589cc50ff43279146e2b3a22a50841b1cc6740943a59d"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/facebook/mvfst/pull/405
  patch do
    url "https://github.com/facebook/mvfst/commit/77dfed2a86bd2d065b826c667ae7a26e642a61d9.patch?full_index=1"
    sha256 "182e642819242a9afe130480fc7eaee5a7f63927efa700b33c0714339e33735c"
  end

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
