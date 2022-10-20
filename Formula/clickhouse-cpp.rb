class ClickhouseCpp < Formula
  desc "C++ client library for ClickHouse"
  homepage "https://github.com/ClickHouse/clickhouse-cpp#readme"
  url "https://github.com/ClickHouse/clickhouse-cpp/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "53eaccb1dbb96f82d27400a8e336bbf59c9bcb15495458c09e4c569717314f17"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ClickHouse/clickhouse-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "26e39ddc384145868d46d4ce393da2743e2835ea5bfc9d8ea0b7eb9820200336"
    sha256 cellar: :any,                 arm64_big_sur:  "36ae89dde556bb4f92e180735c505a7f07ee42e9ee6398a7ec3cedf6aa2d19f6"
    sha256 cellar: :any,                 monterey:       "525f287703a698aeef5daaeeeaf9bf3da115a3bb0019ccd3949edff1ed1c5326"
    sha256 cellar: :any,                 big_sur:        "c4bbc0a458466f26d915f0d88f08aa18146283dd3a70394b4bc2664e4548476b"
    sha256 cellar: :any,                 catalina:       "a682490a810ab9b36f1ff3206ebad0e8c232eccd5e878994bd9644dbd487e0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1751f82002ec0dcc111aa9ce87a38c2b0db23ff14c545563e5558d86839ea79"
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
