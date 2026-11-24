class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 6
  compatibility_version 1

  bottle do
    manifest_sha256 "0f642453391c7b81bd7f60232ff3d8b0f2e2b26e6b59757707c8348535599541"
    sha256 cellar: :any, arm64_golden_gate: "2d2ce0d702215cc9726018f254b14eb747932ca8f9f74696386d5c268df30a14"
    sha256 cellar: :any, arm64_tahoe:       "7631432fbdb9d78efa3281e869a57c6409a5fc69cd263320b240a1b0c7a8d3a3"
    sha256 cellar: :any, arm64_sequoia:     "c2fecdc5d96e2ea4ad3c50fa35c53c51be34f62102cffb5c46cce4d0383c6927"
    sha256 cellar: :any, arm64_linux:       "a12fac2929035447edefb83bf77f102dadceec1b3bb53586bec0b6b1e1d4ac42"
    sha256 cellar: :any, x86_64_linux:      "8c55af72207791390168600dbf1eb5cc1bf6bf7fa50b69f46c1cb5126c9cdd42"
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
