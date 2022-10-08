class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "53eaccb1dbb96f82d27400a8e336bbf59c9bcb15495458c09e4c569717314f17"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "377f009e4829cbbf3fd978a5360b1a47c1661a0b863a1c2e5b4c053308d1e1e2"
    sha256 cellar: :any,                 arm64_big_sur:  "3111e5045934df952b31dd4d85bdcf6dbe189b8ec9ecbcae411b91f6045277c2"
    sha256 cellar: :any,                 monterey:       "b8403a8fe715ccf41b6cfe9f9f77649d5861e5dd4d9a7b9b9e690b81e7031c76"
    sha256 cellar: :any,                 big_sur:        "157259692d2c331b507b96002924e3ae11f88da9f9c2d85761a4cf7827975a5b"
    sha256 cellar: :any,                 catalina:       "081658e3fffc13644721bee90ece9c84079b981a90e6b0bd021334bf14b7104b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a024eae71d06d64c873ac160e28cf0f296557077b7ef2cede2374f01811e32"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "openssl@3"

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DWITH_OPENSSL=ON",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
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
