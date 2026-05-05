class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"
  revision 3

  bottle do
    sha256 arm64_tahoe:   "5826d7642c5bc9fdbb87df242b9fbdc67a225a555be4f9fecf17714798d08030"
    sha256 arm64_sequoia: "047018c738758c5a1670b379e69b0b314c85700f46051528a944d79b57021c09"
    sha256 arm64_sonoma:  "33c43ead20571c7a39acd417020fb3983353b4f27b1e811eaab74d977bb6f089"
    sha256 sonoma:        "4f7e4cb755edc383f0847a56c294ecedde919d1c8736b7885acba19de0529226"
    sha256 arm64_linux:   "62d6fae05072c458fdced8b0155965ef1ee4cb01137b6a0d017381635d5e7648"
    sha256 x86_64_linux:  "399865691c5b514148ff237218015baaf10e367e619c0aa10bc7d0a645d490fe"
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  def install
    system "./configure",
      "--disable-macos-framework",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <sasl/saslutil.h>
      #include <assert.h>
      #include <stdio.h>
      int main(void) {
        char buf[123] = "\\0";
        unsigned len = 0;
        int ret = sasl_encode64("Hello, world!", 13, buf, sizeof buf, &len);
        assert(ret == SASL_OK);
        printf("%u %s", len, buf);
        return 0;
      }
    CPP

    system ENV.cxx, "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lsasl2"
    assert_equal "20 SGVsbG8sIHdvcmxkIQ==", shell_output("./test")
  end
end
