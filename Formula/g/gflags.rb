class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "1b5e0648d7b94021895086e65479b4eaca7935eecfffd7dd9512eb576181c53d"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "edce804ef0a528dd0bea7e40318d2ee95eb17f89c4901efb776e144bdb13aced"
    sha256 cellar: :any, arm64_sequoia: "1738d417945489b66d70a22966a2fc2d0b81ee1b3fc19e36891d02bed73d3671"
    sha256 cellar: :any, arm64_sonoma:  "6d904e4f166314c270735d81930b4ec57fd6594805864e4aebc1753b25c0f86d"
    sha256 cellar: :any, sonoma:        "b215f55b3671a63c6461ce5dbca32b81fd86a7fd0d4388fe5e8910d40130f20b"
    sha256 cellar: :any, arm64_linux:   "bf5794e959e681f19d687ad9f10e366da269d906482943e9455913a657826ffd"
    sha256 cellar: :any, x86_64_linux:  "b4e2eef6a08b9f0d4bd67223e0814e440748fcf08fcce0f0272d1534273440eb"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_STATIC_LIBS=ON
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    ]

    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include "gflags/gflags.h"

      DEFINE_bool(verbose, false, "Display program name before message");
      DEFINE_string(message, "Hello world!", "Message to print");

      static bool IsNonEmptyMessage(const char *flagname, const std::string &value)
      {
        return value[0] != '\0';
      }
      DEFINE_validator(message, &IsNonEmptyMessage);

      int main(int argc, char *argv[])
      {
        gflags::SetUsageMessage("some usage message");
        gflags::SetVersionString("1.0.0");
        gflags::ParseCommandLineFlags(&argc, &argv, true);
        if (FLAGS_verbose) std::cout << gflags::ProgramInvocationShortName() << ": ";
        std::cout << FLAGS_message;
        gflags::ShutDownCommandLineFlags();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgflags", "-o", "test"
    assert_match "Hello world!", shell_output("./test")
    assert_match "Foo bar!", shell_output("./test --message='Foo bar!'")

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(cmake_test)
      add_executable(${PROJECT_NAME} test.cpp)
      find_package(gflags REQUIRED COMPONENTS static)
      target_link_libraries(${PROJECT_NAME} PRIVATE ${GFLAGS_LIBRARIES})
    CMAKE
    system "cmake", testpath.to_s
    system "cmake", "--build", testpath.to_s
    assert_match "Hello world!", shell_output("./cmake_test")
  end
end
