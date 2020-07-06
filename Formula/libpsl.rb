class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.21.0/libpsl-0.21.0.tar.gz"
  sha256 "41bd1c75a375b85c337b59783f5deb93dbb443fb0a52d257f403df7bd653ee12"
  license "MIT"
  revision 2

  bottle do
    cellar :any
    sha256 "a1d53ecac4851b290e62b7753a8a937872bcf039d25acffb40c0b194c669ccbe" => :catalina
    sha256 "7969e5a474336273b2476e7a7a064ce871b64454aa069edd5af3b5c8b223c566" => :mojave
    sha256 "9f2176b329f68042a5748aa51497607e75aa5fd612933e0c5c9afdf0b75cdb75" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "libidn2"

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

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
