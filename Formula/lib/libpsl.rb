class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz"
  sha256 "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "293cdc1b72ebc6aaf89753051e26507003d0cd8fd1ae7c8ba7aac4a1d428eeb8"
    sha256 cellar: :any,                 arm64_ventura:  "a7274d418dc461859a46bdde7389717f181c243ce54a436eecd9a064b4bf7086"
    sha256 cellar: :any,                 arm64_monterey: "6dfef8703104c82bc23ad69a8157c3285013a4564358a634152c17b64375f0dc"
    sha256 cellar: :any,                 sonoma:         "576bb103055cd79d7876b314e32290c125c935b295ac6607eb4c16fcc97ada6d"
    sha256 cellar: :any,                 ventura:        "ad1653690a326eb233da014de1672cf949c4eecff7fb8e21b153b3262df736d9"
    sha256 cellar: :any,                 monterey:       "d5caba4b43e239d909eeb5b951ddad3cfeaee870faf59b37cb05236b3090cb54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "241163ff1b967310778ad589913030f8cca107d3cc287002d7db15b819166fb5"
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
