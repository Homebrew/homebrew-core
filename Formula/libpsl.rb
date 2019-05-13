class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.21.0/libpsl-0.21.0.tar.gz"
  sha256 "41bd1c75a375b85c337b59783f5deb93dbb443fb0a52d257f403df7bd653ee12"

  bottle do
    cellar :any
    sha256 "98c946ebba06f2f0841c5927a8cf40e26cd0a6b93b22f6e8882eb51aa33f962c" => :mojave
    sha256 "8e6d078082a3db2ba057ff8b83ce8f443e59723cf3d5488d0efd453b0670745b" => :high_sierra
    sha256 "e6b5a1ce50ba7a587f1df6be12128bc651eff278faae5e7aab470b8aaff5a7d2" => :sierra
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
