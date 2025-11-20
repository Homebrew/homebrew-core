class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.5/libpsl-0.21.5.tar.gz"
  sha256 "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"
  license "MIT"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f604c524a1fec0cdec0ff57613bdf371771e520eff91ef51783606e3d61f7922"
    sha256 cellar: :any,                 arm64_sequoia: "76b3ffcc154821b448e7f091b75a401782b646d15edcfc4cf1e0a22ed43cfa92"
    sha256 cellar: :any,                 arm64_sonoma:  "8a3705cd2f92fa334a9634983aafca93a208ea50ffcd2e304e1a22ec8673e650"
    sha256 cellar: :any,                 arm64_ventura: "0514d77bc120f490bf90cf7bbab7513ebab16b34a3ffa1a1c8339d79b295ad38"
    sha256 cellar: :any,                 sonoma:        "3aa78d021942e4012a59e090a6313445b30026b3b6b227e4e72e889454dd5de8"
    sha256 cellar: :any,                 ventura:       "c20a154aec0480c5376d926350c1e546e7c35784b2458e8c357134e96ebd72eb"
    sha256                               arm64_linux:   "2f0ed93187bf7b2611dcc0952220847f0967943bf136b6e839ed28b9e8e2cd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc10f9acd16c27df7a1ac79ccbd4b16dae4582ab2715266bac49c59fb08923a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libidn2"
  depends_on "libunistring"

  def install
    system "meson", "setup", "build", "-Druntime=libidn2", "-Dbuiltin=true", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
