class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "d724df55f9d4e13b3028355141c6af08fc7f2cd184d8b531e57f0d4f4a376db9"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b42955f4dd85ff527216e6ea7bc5b7bc0b6c9fefdc12e0e486da8a828fbfef3"
    sha256 cellar: :any,                 arm64_big_sur:  "728aabedffe514a18f43e49f121fae4d50bfcf7eccecfa942f4580a035168f07"
    sha256 cellar: :any,                 monterey:       "89724b1341b84f1f3611ed66bbf16c8fb3c32af36cc17bdef1db37a9084b5a7d"
    sha256 cellar: :any,                 big_sur:        "cd9e75d6000ab927aa483e54161ac28a14936e734c529984c07dd70fc14a5024"
    sha256 cellar: :any,                 catalina:       "1dfc7b327c57b76a173aad4075a14a6aee17f240c7e5660371401b5ecee2e603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97073a69174969b32e67a6990bea1129bdca1c7ba952e8e570d548211bf37015"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

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
