class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7664e28a09fde07abd9982785b7662f71d4a7005238059cd207d03f089860c98"
    sha256 cellar: :any, big_sur:       "cca68ebcc18f7c0d993154ec58ceabec6a48ff006e58ec6973c292c81fe2b8f4"
    sha256 cellar: :any, catalina:      "8c383425335b5c19caa8098abb045cedf06bd8ac8be7c67e9f96ee5c0625af80"
    sha256 cellar: :any, mojave:        "f8c81b7c252abaf169f768923703d9b1eeb9b8c9e89e3a48f4383670b16c8503"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
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
