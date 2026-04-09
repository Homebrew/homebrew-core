class FfcH < Formula
  desc "Single-header C99 accelerated float/double parsing"
  homepage "https://github.com/kolemannix/ffc.h"
  url "https://github.com/kolemannix/ffc.h/archive/refs/tags/v26.03.4-test.tar.gz"
  version "26.03.4-test"
  sha256 "2a89445d5d29e4a24e00eb9b0c7167286a6d38216c238069b6be512fe0568f95"
  license "Apache-2.0"
  head "https://github.com/kolemannix/ffc.h.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3f9022900ce2b6a548287f7842ab9dfde151058c9c4edfce2fc89ed0689538b6"
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
