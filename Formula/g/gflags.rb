class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "f619a51371f41c0ad6837b2a98af9d4643b3371015d873887f7e8d3237320b2f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dd2b968003c63083b15c69ecc4902a28fd36c7409c1e88ede63d5faa4e2e2b9"
    sha256 cellar: :any,                 arm64_sequoia: "150daa47c6677e77d7b4b5ecbf4131757d379810573abfe96a10dba9e325a717"
    sha256 cellar: :any,                 arm64_sonoma:  "5b8d5d59b8556457857815ef949e672d740f2a6523fe56eaf3601f13a321bfe1"
    sha256 cellar: :any,                 sonoma:        "8a01f5f757402fdfc436ff278fd1988984ce910a7cc44d7f9d2901e843dfad2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c1356150c965da7ffd93842cfaf9d061e1db82fcc289814b5f100272bc42895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27d9f2de0ead506066335e1b0c3df598cd1a7a2c1eed7c961763204563f70b0"
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
