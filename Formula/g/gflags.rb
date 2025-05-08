class Gflags < Formula
  desc "Library for processing command-line flags"
  homepage "https://gflags.github.io/gflags/"
  url "https://github.com/gflags/gflags/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "6d56871afa5b934f97b811e188ce357550e046e36f320d5be3eb09cf35331f03"
    sha256 cellar: :any,                 arm64_sonoma:  "6b1cf8099e5abdd2dd9948c9527737df99507a8fce5a685872801a2bfe7f2fba"
    sha256 cellar: :any,                 arm64_ventura: "51d795a7791983c1f5e2f092f58d35527d9420f39dcdad8e21b6b5e334ea3d3a"
    sha256 cellar: :any,                 sonoma:        "a3a1354b658df7e0c285172ec7ae98ef8903d5cdf4d6257ff04b17ae67dbfb29"
    sha256 cellar: :any,                 ventura:       "5373529f723aaf297d200782468fbbe09f08a5b928fcfe960e3f096b00a5aac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8555f37bfc6ea600fe9b8e6fd996c09f2fa21a4649c928c7c6aed976f19b7833"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f486b9a259f3870ad31ada739a0c95050a435c6e0b5ed5f694773b65bd0c223"
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
