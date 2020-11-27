class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.21.1/libpsl-0.21.1.tar.gz"
  sha256 "ac6ce1e1fbd4d0254c4ddb9d37f1fa99dec83619c1253328155206b896210d4c"
  license "MIT"
  revision 2

  bottle do
    cellar :any
    sha256 "78fffedcd4db590a59c3f6c0cee4cc06745f12c12bcd55ca86312480e9dc4346" => :big_sur
    sha256 "c20b9de4b0106e4d7175b7518b09312ad2d07c23ed55db72eea66d3490a0828c" => :arm64_big_sur
    sha256 "556831eb0cbd09ab25778ce94edcbc25e111ab777f80b2e85e9610c0187fa1a6" => :catalina
    sha256 "e4143e4f14c0182904d8680de693f5dbbc4ec3292655fe044ec1f23d7901631f" => :mojave
    sha256 "62824a3515a7c8c7847fff9d91caa21dbca05653ccbd6bdf29805ee0cfbaa73c" => :high_sierra
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
