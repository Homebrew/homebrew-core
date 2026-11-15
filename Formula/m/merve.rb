class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 5
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7a7d2396e5b8f945e9e180465869f7635502295ac59517e1a9854687ad3bdcea"
    sha256 cellar: :any, arm64_tahoe:       "a7478a309126cd74997be855cf8c0e2eccaf3c0da2c8b85d45e60ebdb01d9b36"
    sha256 cellar: :any, arm64_sequoia:     "feb23bbedbc47af4ed30ce7da8187a3b989894c630d26046730e04a3e0e93354"
    sha256 cellar: :any, arm64_linux:       "eaeb49403463ace65982c8148ddf5e4faf4d9ffeac67c11ca3a1ba96dbf60181"
    sha256 cellar: :any, x86_64_linux:      "4148080cf7ed8f75899f38d9e05609a95fee7e7d3bbdd4a4876bb7ef67e0bf39"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  deny_network_access!

  def install
    args = %w[
      -DMERVE_TESTING=OFF
      -DMERVE_USE_SIMDUTF=ON
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test-merv.c").write <<~'C'
      #include "merve_c.h"
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *source = "exports.foo = 1;\nexports.bar = 2;\n";
        merve_analysis result = merve_parse_commonjs(source, strlen(source), NULL);
        merve_string export_name;

        if (!result || !merve_is_valid(result)) return 1;

        export_name = merve_get_export_name(result, 1);
        printf("%zu %.*s %u\n",
               merve_get_exports_count(result),
               (int) export_name.length, export_name.data,
               merve_get_export_line(result, 1));
        merve_free(result);
        return 0;
      }
    C
    system ENV.cc, "test-merv.c", "-I#{include}", "-L#{lib}", "-lmerve", "-o", "test-merv"
    assert_equal "2 bar 2\n", shell_output("./test-merv")
  end
end
