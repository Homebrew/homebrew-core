class FfcH < Formula
  desc "Single-header C99 accelerated float/double parsing"
  homepage "https://github.com/kolemannix/ffc.h"
  url "https://github.com/kolemannix/ffc.h/archive/refs/tags/v26.04.01.tar.gz"
  sha256 "bc36f6c95357b7da75b54fb794eb4272b0e53a867f48c8aab6c900941dfac170"
  license "Apache-2.0"
  head "https://github.com/kolemannix/ffc.h.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4422599ff0a06b3fefe73bd9d2d67f4fc3d32c903b66ee0da42dd0c3d483bfa"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = %w[-DFETCHCONTENT_SOURCE_DIR_SUPPLEMENTAL_TEST_FILES=/dev/null] # unused
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    # Header-only, so we don't need to do `cmake --build`.
    system "cmake", "--install", "build"
    # Ensure the CMake config file has a name that can be found by CMake.
    (lib/"cmake/ffc").install_symlink "ffcTargets.cmake" => "ffcConfig.cmake"
  end

  test do
    (testpath/"ffc-test.c").write <<~'C'
      #include <stdio.h>
      #include <string.h>

      #define FFC_IMPL
      #include "ffc.h"

      int main(void) {
         char *input = "-1234.0e10";
         ffc_outcome outcome;
         double d = ffc_parse_double_simple(strlen(input), input, &outcome);
         printf("%s is %f\n", input, d);

         char *int_input = "-42";
         int64_t out;
         ffc_parse_i64(strlen(int_input), int_input, 10, &out);
         printf("%s is %lld\n", int_input, out);

         return 0;
      }
    C

    system ENV.cc, "-I#{include}", "ffc-test.c", "-o", "ffc-test"
    system "./ffc-test"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)

      project(ffc_install_test LANGUAGES C)

      find_package(ffc REQUIRED)

      add_executable(ffc_install_test ffc-test.c)
      target_link_libraries(ffc_install_test PRIVATE ffc::ffc)
    CMAKE
    ENV.prepend_path "CMAKE_PREFIX_PATH", prefix
    system "cmake", "."
    system "cmake", "--build", "."
    system "./ffc_install_test"
  end
end
