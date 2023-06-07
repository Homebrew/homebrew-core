class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.gz"
  sha256 "e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7518afd0130f15500f4fd4d5c8ed43cee3b0e3c8c237a12bb3e9adbc4a6ec4cb"
    sha256 cellar: :any,                 arm64_monterey: "7cb1d77973b8fdfa4a2804ae69434ec3cf4248a906d3a46b66e29f9920843f48"
    sha256 cellar: :any,                 arm64_big_sur:  "5050c1c715b46f55ed6c96fcc00cebb682847c714bf225aadb18fe6b4c3f84f6"
    sha256 cellar: :any,                 ventura:        "7c48120e1842b1ef8909e1f0310e613aadc67ca2799f216b1a88603964a815e1"
    sha256 cellar: :any,                 monterey:       "6a021e3c659939c49c53d04a7f4ad7b9333b37c9f05587731c5a1024c15c71da"
    sha256 cellar: :any,                 big_sur:        "95a808735dbfb307e8e3ab1a747fd8ecd82ab57bd31a72c8c2b40d71047c05b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7cd47ce99f50e717ef2af9c82964912cac03e3e0659e818d689294604094ba2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
