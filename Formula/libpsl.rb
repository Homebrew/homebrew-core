class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.21.0/libpsl-0.21.0.tar.gz"
  sha256 "41bd1c75a375b85c337b59783f5deb93dbb443fb0a52d257f403df7bd653ee12"

  bottle do
    cellar :any
    sha256 "4d425f864c29546393f0b6dd4d53cff8c3b4421822a1ad84b073c0cad665eea3" => :mojave
    sha256 "6c785199ea0e69a1e227ee3d82d302cc2f57d4e457105cd50adf54beb2574318" => :high_sierra
    sha256 "2e9e468c9c2fe6744250870be81f207d1133aa88299c76d920470f6c9102737e" => :sierra
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
