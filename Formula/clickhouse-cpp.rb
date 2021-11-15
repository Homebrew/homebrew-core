class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/1.5.0.tar.gz"
  sha256 "bb6f268f9c788deb9beccb0b05c2caccf77b141afa408343e09993f12bff55a9"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9fd21882b8f4db81bcdb7eda8512caedf06970c6171822098f7ea30a9fe1602d"
    sha256 cellar: :any,                 arm64_big_sur:  "5474994e7b1cee4b8a59dd29d1a4d8ebfdca4ae8b950e78b16fba2beaa085ab1"
    sha256 cellar: :any,                 monterey:       "1786787278c6a9b5060a622b3ef5becf23c33afb3e4ac5e5afc1b9f8da95bec7"
    sha256 cellar: :any,                 big_sur:        "b9ad77091970889f729e933ebba966805e24a798077a8b1f7dbedfd03085e4b3"
    sha256 cellar: :any,                 catalina:       "2ce4a74242a33abc278c17a5fd51f82dfe427a014e06170ed89dedc4c41fc807"
    sha256 cellar: :any,                 mojave:         "cc2b93d7b7727a606a9554ff0346f8027880c72b5cd95aadb4789fad578d809e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c98ae1539ce939c7907e4646860067ba29da9265ae581c3bb38cb1feafe7468"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
    EOS

    system "cmake", "-S", testpath, "-B", (testpath/"build"), *std_cmake_args
    system "cmake", "--build", (testpath/"build")

    assert_match "Exception: fail to connect: ", shell_output(testpath/"build"/"test-client", 1)
  end
end
