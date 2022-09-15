class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "53eaccb1dbb96f82d27400a8e336bbf59c9bcb15495458c09e4c569717314f17"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "40ef8f4f3bc27a5ee551b8f7c4e8ef318807a7971d519d6b0065fa4925ac7bd6"
    sha256 cellar: :any,                 arm64_big_sur:  "381e2ceafc379b18af83bd0d9a2818ec68cfa8ba7106bc3efacc0494fc3fac2b"
    sha256 cellar: :any,                 monterey:       "c22c3635df58255958a0aa8079ed69a106ac3630c9ac15945e219e44644d66e8"
    sha256 cellar: :any,                 big_sur:        "c71ab093cebbb1a3bbd45a7dc67f83ff93be4bb1525f4b3b2530d5f4d4efddd9"
    sha256 cellar: :any,                 catalina:       "0b322aada774fac76d78b280a6d178d5a7d470c4267f122aab44355b10989ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5122312978fc0dc91995dddbba8d0f7bc8f9d95e6eab4f7ec7584b1ae775fb3d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "openssl@1.1"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DWITH_OPENSSL=ON", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"main.cpp").write <<~EOS
      #include <clickhouse/client.h>

      #include <exception>

      #include <cstdio>
      #include <cstdlib>

      int main(int argc, char* argv[])
      {
          int exit_code = EXIT_SUCCESS;

          try
          {
              // Expecting a typical "failed to connect" error.
              clickhouse::Client client(
                clickhouse::ClientOptions()
                .SetHost("example.com")
                .SetSendRetries(1)
                .SetRetryTimeout(std::chrono::seconds(1))
                .SetTcpKeepAliveCount(1)
                .SetTcpKeepAliveInterval(std::chrono::seconds(1))
              );
          }
          catch (const std::exception& ex)
          {
              std::fprintf(stdout, "Exception: %s\\n", ex.what());
              exit_code = EXIT_FAILURE;
          }
          catch (...)
          {
              std::fprintf(stdout, "Exception: unknown\\n");
              exit_code = EXIT_FAILURE;
          }

          return exit_code;
      }
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      project (clickhouse-cpp-test-client LANGUAGES CXX)

      set (CMAKE_CXX_STANDARD 17)
      set (CMAKE_CXX_STANDARD_REQUIRED ON)

      set (CLICKHOUSE_CPP_INCLUDE "#{include}")
      find_library (CLICKHOUSE_CPP_LIB NAMES clickhouse-cpp-lib PATHS "#{lib}" REQUIRED NO_DEFAULT_PATH)

      add_executable (test-client main.cpp)
      target_include_directories (test-client PRIVATE ${CLICKHOUSE_CPP_INCLUDE})
      target_link_libraries (test-client PRIVATE ${CLICKHOUSE_CPP_LIB})
      target_compile_definitions (test-client PUBLIC WITH_OPENSSL)
    EOS

    system "cmake", "-S", testpath, "-B", (testpath/"build"), *std_cmake_args
    system "cmake", "--build", (testpath/"build")

    assert_match "Exception: fail to connect: ", shell_output(testpath/"build"/"test-client", 1)
  end
end
