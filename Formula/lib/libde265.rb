class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.17/libde265-1.0.17.tar.gz"
  sha256 "e919bbe34370fbcfa36c48ecc6efd5c861f7df43b9a58210e68350d43bab71a5"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe4d87cc31754c2b6978c0e8a0b09d45d5cea0549e9073632bd30f8b7c19fa56"
    sha256 cellar: :any,                 arm64_sequoia: "fe3f4a0cc875c061b603f24d39eba50858d505be689853e4eb395336f2bd3911"
    sha256 cellar: :any,                 arm64_sonoma:  "1751024b00250804a845f96c4f8baac2eeb5e307097539fabb0817a8441d5ee1"
    sha256 cellar: :any,                 sonoma:        "6e056da3e680edf885dc1366b4b6dc58499e5de3293efb36cf7de83e0c473d53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b66c01335c2fcc2800d8fff52353203ef78b1e5b565d8af5f343636358a8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9897f5e9c4124737a45b051e970d7da80901f6f6b61ce0d78345405f4bec20d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: libexec/"bin")}",
                    "-DENABLE_DECODER=OFF",
                    "-DENABLE_TOOLS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install the test-related executables in libexec.
    (libexec/"bin").install bin/"block-rate-estim",
                            bin/"tests"
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

    assert_match "list ... passed", shell_output("#{libexec}/bin/tests")
  end
end
