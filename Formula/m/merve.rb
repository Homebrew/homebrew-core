class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "28d55ca685235ca09cafac7c50c6b00dc1b2b372a3a64121b705ae09bbf3812b"
    sha256 cellar: :any, arm64_tahoe:       "4713f644af3e19e11aca6fdeeb641899bce180bba8b480621165aac16c2654be"
    sha256 cellar: :any, arm64_sequoia:     "54b5a9258d8b1b15be4d1636efe4649cc3c31e9df50afb5b7469507cf6e00e1c"
    sha256 cellar: :any, arm64_linux:       "e714a777d6c39fd86f91a53a90240ad33ebda81dfb95202e2995ac5fbfe4d15e"
    sha256 cellar: :any, x86_64_linux:      "a21b8e9f164031cf60687eb59bf54bae65d1dba0019a2e53679449ad14f69735"
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
