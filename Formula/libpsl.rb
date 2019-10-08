class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/libpsl-0.21.0/libpsl-0.21.0.tar.gz"
  sha256 "41bd1c75a375b85c337b59783f5deb93dbb443fb0a52d257f403df7bd653ee12"
  revision 1

  bottle do
    cellar :any
    sha256 "443d1be7d403015d313b2980912b0d2ebadc2988c3989c3bef028ab29daea72b" => :catalina
    sha256 "762188236f81b927f3c86f4e1d42f9dd647534d6bf12f1bf724308a692e8948d" => :mojave
    sha256 "3d63876a24e0f165ce10cd7247d51e2d1520f2a4124f65a611a0f0cf0cfe5851" => :high_sierra
    sha256 "267c60bed429c9f7b0ccc79a936daaf1fae1ad0e3165915f08c0a1d5afbf7178" => :sierra
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
