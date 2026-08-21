class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10e51d2bb647448560a8100eb9ec8d92c514fe04d5ede26cef9555c40de0a663"
    sha256 cellar: :any, arm64_sequoia: "574ecf671b017f29897d390cfcd61d22377e24a8bbdcd24afb6a2fe9cdec859c"
    sha256 cellar: :any, arm64_sonoma:  "75ac946ad847967ea3a50c4bdd6e406ee9e2b6f765353c6e1cb5fdc9db3bd5b6"
    sha256 cellar: :any, sonoma:        "f9a04ff6b6000b4b343ef47697be850a772a7e6c4d6b839347cbd99ca4ff2578"
    sha256 cellar: :any, arm64_linux:   "d0f9f279d12c8bbf40dd5274fce79be027ece0bc4dd800b6ba06d9962e45d2e9"
    sha256 cellar: :any, x86_64_linux:  "20e38bce532a9553a8521da8f52c0de05fa336e632404438cbd05fd6a58ae07b"
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
