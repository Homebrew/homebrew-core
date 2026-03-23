class Libde265 < Formula
  desc "Open h.265 video codec implementation"
  homepage "https://github.com/strukturag/libde265"
  url "https://github.com/strukturag/libde265/releases/download/v1.0.18/libde265-1.0.18.tar.gz"
  sha256 "800478f3bf35f0621b14928ceb317579f3e8b23de4bd2aac29b6cb8be962bbd8"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e332c5e491ae7f70b8ebae1c9f293585b7752a7afaab7333fb8ef9575812544a"
    sha256 cellar: :any,                 arm64_sequoia: "46bfe532b550fbee788b2a270af0adddd6814631cfbab5ec8072a731fb3aeb69"
    sha256 cellar: :any,                 arm64_sonoma:  "03ea2640c729029695efd091b57d981467e9fa10c7cc68e76a26fa34a0fba23a"
    sha256 cellar: :any,                 sonoma:        "2d42dca33ab978407dcf81e723123edeaa37adefd99c271c620b71195da0fa24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd498520b9d66240acd346b1456d3dd0fe7441467da243cb806db8a79ee3dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c17c4d65e7a4c2eafd1c5801d67bf1f6ef8edcd9e79c8dd9a650e07312a4b44"
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
