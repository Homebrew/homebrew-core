class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.20.2/libpsl-0.20.2.tar.gz"
  sha256 "f8fd0aeb66252dfcc638f14d9be1e2362fdaf2ca86bde0444ff4d5cc961b560f"
  revision 1

  bottle do
    cellar :any
    sha256 "214496e72b0938aa38e8db48ac140f9e43506a4955dc6172e2c951f3bd84bb2d" => :mojave
    sha256 "5432b16f21cd209c35550a6fca9434eae5898c271fcd1e2a1ea913f3f49be0ed" => :high_sierra
    sha256 "543687dc43036305716a915fcd478edfa923c1c66cc68b93eba568e999a2bf02" => :sierra
    sha256 "4c7e86b3f5cb0db974a68b5aef377fd4045df26268efee197f6e4397bde24104" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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
    system "#{bin}/psl", "--help"
  end
end
