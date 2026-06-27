class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "762282750ff31f5f38c273aa346bcaefe71d9f488b222e0e67686eb55a5187fc"
    sha256 cellar: :any,                 arm64_sequoia: "04998f770171f826772a0db12bc60cda32c83fcddfde1c3143c4a336062d9155"
    sha256 cellar: :any,                 arm64_sonoma:  "90ae194c060574e94e394da3181cbe98f7077d3ffc3fa0b3470f77651fc510ac"
    sha256 cellar: :any,                 sonoma:        "2b74b54491f8c2f601a5bf649b9c6a94f0e55bce1b7f6e56451b1c7e8a262037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2e3e038d8c3bf94ec942c72371ddc5d4197aeab478d36f5c5d114053073e9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1ac2932467d47af1c0e9441730f23ff9badf7698695d868bab4ec8738a4ddb"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

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
