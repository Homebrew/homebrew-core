class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eb81276048e809a4c28176af2240e5609180e0cc8e2aeef4fdc79c12fa7b97bb"
    sha256 cellar: :any, arm64_tahoe:       "573b28f8a25f0b55132b83517661ad24408af9834c8f04f35ef6fab1db3b5432"
    sha256 cellar: :any, arm64_sequoia:     "050ddc221175cdc56757c1d3b4bba486159470bbf9b9a79ce14931b488168276"
    sha256 cellar: :any, arm64_linux:       "5d8412dc4a0a5b39e48fa2572a4f68fc55fba6c831663455a3d741b3646b3023"
    sha256 cellar: :any, x86_64_linux:      "5fe0317b17f744a2473976a7c4a3e8ba8a0e42288a886f428761c62177403938"
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
