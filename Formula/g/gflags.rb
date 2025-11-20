class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "39734f92f5ba9261156f77cff1ccb83f372b426d6062a380216f4f52f4d491ab"
    sha256 cellar: :any,                 arm64_sequoia:  "5a17163fb7c8fb712f7bee2776e6304e54bb4e7116fe3abb6d2689b1042f8a60"
    sha256 cellar: :any,                 arm64_sonoma:   "1b14d0fd5ab4d2d04ff229bf7cace191208d62a3dc67029151ce1140ecf81258"
    sha256 cellar: :any,                 arm64_ventura:  "9ff5d9da1a4c1d22229f1fb75293a2e115bb431b498dac7c4a42f52378353c50"
    sha256 cellar: :any,                 arm64_monterey: "09ec6001e46f675b1e2bf64ed3ffd6ee8072d36facf38791d1ceeed0c2472daf"
    sha256 cellar: :any,                 arm64_big_sur:  "e1d58af2280acd284f60e87ba07a66ad190188c0a5356ac2a8045799e390c435"
    sha256 cellar: :any,                 sonoma:         "321726b70ab6bd017807ce202a11cf5d356c85c68412ed409edf03019db922f8"
    sha256 cellar: :any,                 ventura:        "6b24b7f057edb2c37d9f423d29ead9a1ebf14e07217f43e0fb7bbf8393b0821c"
    sha256 cellar: :any,                 monterey:       "0436095f47bef8a2165b1829eb8ee6e77c8aa14553ef982bd3c6ecf5c7e9d47b"
    sha256 cellar: :any,                 big_sur:        "4702020c64f73c2e3e23997055a49711600a1af7834652be3923a1edb43a750c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "03c55bb2c70aaab30bf92eab3d2d90880eb647e2c9f070943b12a7723f0723eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f11fa1aff8e21d32012f8fbb78a2f954241f4e026b8518a6c874e2d537201629"
  end

  depends_on "cmake" => [:build, :test]

  # cmake 4.0 build patch, upstream pr ref, https://github.com/gflags/gflags/pull/367
  patch do
    url "https://github.com/gflags/gflags/commit/b14ff3f106149a0a0076aa232ce545580d6e5269.patch?full_index=1"
    sha256 "84556b5cdfdbaaa154066d2fdd6b0d1d90991ac255600971c364a2c0f9549f84"
  end

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
