class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.1.3/libde265-1.1.3.tar.gz"
  sha256 "554228bd17788c99a7e63b37ab5634722190e6e2bf60c1dcb01cef328e133905"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d4a7527bce91d5e261c297435689a9987776c7dcd8cbfe4ab2ee159550594756"
    sha256 cellar: :any, arm64_tahoe:       "46ae0a2e5d873fb1fe88b2855a67668eb805712073acb5d532fd3081fc2cbfe0"
    sha256 cellar: :any, arm64_sequoia:     "12810efc8cf343799cc9619ebe99f41248c5a5c07efcfa3c73d7c5488a976cbe"
    sha256 cellar: :any, arm64_linux:       "8bc7152ed0d8cf619db552002fa0f8a86d9800265727356d33246a5f84585058"
    sha256 cellar: :any, x86_64_linux:      "275b0272f1e00f83aaeaaf33493de34759c3408911ef8e0f60a6ba7e6698f376"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}",
                    "-DENABLE_DECODER=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~'C'
      #include <libde265/de265.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        de265_decoder_context *ctx;
        const char *version = de265_get_version();

        if (strcmp(version, LIBDE265_VERSION) != 0) {
          return 1;
        }

        if (de265_init() != DE265_OK) {
          return 2;
        }

        ctx = de265_new_decoder();
        if (ctx == NULL) {
          de265_free();
          return 3;
        }

        printf("%s\n", version);

        de265_free_decoder(ctx);
        de265_free();

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lde265", "-o", "test"
    assert_equal version.to_s, shell_output("./test").strip
  end
end
