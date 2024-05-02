class Mvfst < Formula
  desc "QUIC transport protocol implementation"
  homepage "https://github.com/facebookincubator/mvfst"
  url "https://github.com/facebookincubator/mvfst/archive/refs/tags/v2024.04.29.00.tar.gz"
  sha256 "53b68992ea42cad1afdd88faea06960d51f5792f8ed0a7b91ad6d17816c99d42"
  license "MIT"
  head "https://github.com/facebookincubator/mvfst.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc0453305aac311f160e000cc0789c27d2c89bfec2564c6d11e5ef720e1c718b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11677e7de29817a990e258b9a2255c2887d61e6dcf09b4eec499216707737f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "341e5fe9db8222960cea98105026529263f22be486fc56773d7be170efb78bac"
    sha256 cellar: :any_skip_relocation, sonoma:         "3211389a7712bbbaca8e9fd6c80a4aca2f4f38107bbf6ae690ff94ff5540c66e"
    sha256 cellar: :any_skip_relocation, ventura:        "e087c5393d08ddb6506ca7553daf576441746153018746b1282f12d86f014de6"
    sha256 cellar: :any_skip_relocation, monterey:       "d3d6c58739237b454be6f0fe36112fe58445e9be962c9a8706a61c4801bb48d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01a4e0d0df254bc2cfad24a3553ef1ca294cd383780090c167192b78a797b37d"
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
