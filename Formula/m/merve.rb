class Merve < Formula
  desc "C++ lexer for extracting named exports from CommonJS modules"
  homepage "https://github.com/nodejs/merve"
  url "https://github.com/nodejs/merve/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8f19c2132447b9113545ffd399cb2bc1e61c6166743921b04883f8e1d778d69e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0b41d6a9b45460e7fd65eb26833e136ffc7f33f5d2362db2f3d78e1bb2deb073"
    sha256 cellar: :any,                 arm64_sequoia: "b75e744bcc229153ed43e9c272f79133d44161f39f2b0e3d54de157b0084a20d"
    sha256 cellar: :any,                 arm64_sonoma:  "0d89c962210d30ca7573f0283ecc3ea306eed2c3f77976dbea84598aa5381fec"
    sha256 cellar: :any,                 sonoma:        "14087e337f17b1facee97520fa4494ace436474aab683dd65ec993d9f9e594e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46c11758a8a95905c18d5f5972eb1e243c3fe9c01e3649fb545ab32af96a5d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc11fc91bd7d6562fe496c2cb1b9fb6dc4c6f5e6d1d18eade0cb7f45f348981"
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
