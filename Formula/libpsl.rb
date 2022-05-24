class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "52877267862937c5097b44524683cdeb205298fe3fa651b6f83c83b940c0892a"
    sha256 cellar: :any, arm64_big_sur:  "78ab442965d78a50490623107591c851b04a0f4728033e32820f0bb8de034b03"
    sha256 cellar: :any, monterey:       "8b8f8ec3a0109a21c4f7bbb69dd464ac40222a4082f87eef57a3bc2c9e855ad3"
    sha256 cellar: :any, big_sur:        "1eb5c356cc0e6a3ee625cd9863eec0bfa5d0a200385e21886633e8e3f90ddee8"
    sha256 cellar: :any, catalina:       "e2a728ee40470514e776e529e6ea1341467b20558c9bddd216336a0d925442eb"
    sha256               x86_64_linux:   "a3826e9daf5f44f094ac7d5723db2072d62507d285dff24f37ce0715b823d223"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "icu4c"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Druntime=libicu", "-Dbuiltin=libicu", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
