class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz"
  sha256 "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72f334f8492ea88cc42d1c1cbf9caed0cc95eddf79a00dc2298a17fd98ca0fdd"
    sha256 cellar: :any,                 arm64_ventura:  "40df0dc5de78fc9d3f4bbfca4988a14def101ee75802f0e009448aec3279481f"
    sha256 cellar: :any,                 arm64_monterey: "e4074b1c27b904fcc7536013bac0b82ee7bbf5b1e556c185bf92c0c42c2d8684"
    sha256 cellar: :any,                 sonoma:         "8616a029a8697f21768ca908014aa0fb809958815c8c62cd850c421b95203c22"
    sha256 cellar: :any,                 ventura:        "bbc78df069c704feddb6a74d1e507b0d69fc58fef414afbc9421a24659645464"
    sha256 cellar: :any,                 monterey:       "049bb0a67f33453df85d1dc2568fd52959ac5ac2549a9c4b54191ac3859aa0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b8a8d4dfe0081a71acc9033dbfa81105e7e2a0c571dc1ca577573701f5aa14"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"

  def install
    system "meson", "setup", "build", "-Druntime=libicu", "-Dbuiltin=true", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include <string.h>

      #include <libpsl.h>

      int main(void)
      {
          const psl_ctx_t *psl = psl_builtin();

          const char *domain = ".eu";
          assert(psl_is_public_suffix(psl, domain));

          const char *host = "www.example.com";
          const char *expected_domain = "example.com";
          const char *actual_domain = psl_registrable_domain(psl, host);
          assert(strcmp(actual_domain, expected_domain) == 0);

          return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
