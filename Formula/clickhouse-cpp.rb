class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "8eb8b49044247ccc57db73fdf41807a187d8a376d3469f255bab5c0eb0a64359"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d416b409e0b3ea994d1862f98423903676b157bcb394b17b3ebbbd955f720620"
    sha256 cellar: :any,                 arm64_monterey: "ad860cfc340915f420ac3a0f9f43a4ededae2af88f1f9d82d325ee78b59b7a81"
    sha256 cellar: :any,                 arm64_big_sur:  "c1c3be5c26eba1691038d78ae71872f9b05674bde112b59f8f829045a82808a4"
    sha256 cellar: :any,                 ventura:        "b0546b51446c0e27351f1890de99746d2fbd3b85053b8d21f299861515d15294"
    sha256 cellar: :any,                 monterey:       "1c76150b5684c38b6cafc40fdf26a4eec68f664fab64b5cf672d9bd3623e50b0"
    sha256 cellar: :any,                 big_sur:        "55b7fde1c2ac15a34defc526a4ccb12107c757263f5202ac7fc72d81d91ef572"
    sha256 cellar: :any,                 catalina:       "b1a57158ed078088f38ce5da4207b4c10544e9268c35a17dd867e5788807ae7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59b4a9754fd3934831f20c2efe2398c4a56b4e7fb0de43aff7a50642e80b4bf6"
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
