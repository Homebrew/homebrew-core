class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.2/libpsl-0.21.2.tar.gz"
  sha256 "e35991b6e17001afa2c0ca3b10c357650602b92596209b7492802f3768a6285f"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d807358832a47838ecacf3d1ee98f79919b43e949340ec829de9ed78281969a1"
    sha256 cellar: :any,                 arm64_monterey: "461a1506da60b3bdd7722238164a0aa041cef1cea5ffd5f4ccce220d389ceadf"
    sha256 cellar: :any,                 arm64_big_sur:  "4d9f1c6738cee9a5cf3c602318fed5d4bbeaeb97be075e271d78049b2bbf0dcc"
    sha256 cellar: :any,                 ventura:        "c0f1c15f6c95e9549e0507ecf1a51a29c303519c176a1ee58c18f7dfc3558c5c"
    sha256 cellar: :any,                 monterey:       "bd2872748424c5f519b73c9eb3b3f1d5293c4b6f24bd43d94a62b57fc573e616"
    sha256 cellar: :any,                 big_sur:        "389df6b5e877a389b31e83cb3d3bb0bc8bce6e0acf286d5a0ed308dd4d0fd183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9f8d5928df57c06659a206cf6994e7688eb182990a38f9c968afb41d6061aa"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "icu4c"

  def install
    system "meson", "setup", *std_meson_args, "build", "-Druntime=libicu", "-Dbuiltin=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libpsl.h>
      #include <assert.h>

      int main(void)
      {
          const char *domain = ".eu";
          const char *cookie_domain = ".eu";
          const psl_ctx_t *psl = psl_builtin();

          assert(psl_is_public_suffix(psl, domain));

          psl_free(psl);

          return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lpsl"
    system "./test"
  end
end
