class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  stable do
    url "https://github.com/flame/blis/archive/0.8.1.tar.gz"
    sha256 "729694128719801e82fae7b5f2489ab73e4a467f46271beff09588c9265a697b"

    # Fix non-generic build for Apple ARM and compilation with Clang.
    # Upstream ref: https://github.com/flame/blis/pull/506
    # Remove in the next release.
    patch do
      url "https://github.com/flame/blis/commit/bf727636632a368f3247dc8ab1d4b6119e9c511a.patch?full_index=1"
      sha256 "55962e5df20308c08a5b10a2b7186268dfc905127e360af17e271198d2cde687"
    end

    # Allow using `thunderx2` config on Apple ARM with Clang
    # Upstream ref: https://github.com/flame/blis/pull/492
    # Remove in the next release.
    patch do
      url "https://github.com/flame/blis/commit/6548cebaf55a1f9bdb8417cc89dd0444d8f9c2e4.patch?full_index=1"
      sha256 "c7f2ae70662b33f8db0aeb2773467288a9fba03fd26005d71d9ac0b9ff712c60"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08a927f8360cd8cf29762341a080e86bda1a84098fdd99884136f0a25e10cf2e"
    sha256 cellar: :any,                 arm64_big_sur:  "971251c831592d168e0ccafb67e47de2430433ea395663c788db7223a5ac6f3e"
    sha256 cellar: :any,                 monterey:       "3d7e6df045340294770f76b78e015cf7c6e1401f9efe11250c3741a68a8f42f0"
    sha256 cellar: :any,                 big_sur:        "ad2e6862fd4b5a425769c108e7a36e33ac7e7fc77ce699756fe051e68524518d"
    sha256 cellar: :any,                 catalina:       "b26e5e7deb7b85319fa539a061ff84df842378a902e3695a4f6df63eba9f5cdb"
    sha256 cellar: :any,                 mojave:         "333cceec593098d68f438ddcfc6415d44cf0af565601c0163496e23bdf4a8aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7726592ecf1b90f66c73ca7be6f18a76ff9a208887e677e291a81036b467a3e9"
  end

  on_linux do
    depends_on "gcc" => [:build, :test]
  end

  fails_with gcc: "5"

  def install
    # Work around for Apple ARM as there isn't an optimized framework config yet
    # and auto-detection isn't implemented. With patches, we can use existing
    # `thunderx2` config, which probably performs better than `generic` config.
    # This should be changed when Apple ARM-specific config is available.
    # Ref: https://github.com/flame/blis/issues/495
    # Ref: https://github.com/flame/blis/pull/492#issuecomment-850797713
    config = Hardware::CPU.arm? ? "thunderx2" : "auto"

    system "./configure", "--prefix=#{prefix}", "--enable-cblas", config
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "blis/blis.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lblis", "-lm"
    system "./test"
  end
end
