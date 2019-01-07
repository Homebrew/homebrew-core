class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.20.2/libpsl-0.20.2.tar.gz"
  sha256 "f8fd0aeb66252dfcc638f14d9be1e2362fdaf2ca86bde0444ff4d5cc961b560f"
  revision 1

  bottle do
    cellar :any
    sha256 "42a57365960939d5f4b7f944d530ae22d2f316143e269021554edcf297fa5850" => :mojave
    sha256 "ce7f00eaebb1e0300c841f5d6a6ef6e86b40ba6003ed07302d4c773c6ee6733a" => :high_sierra
    sha256 "c7c5f3f20391cfa17f0461e48a8cf3a74e2d9ea7b69b82fdfcb2085443677ffe" => :sierra
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
