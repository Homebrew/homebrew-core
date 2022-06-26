class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"
  revision 1

  bottle do
    sha256 arm64_monterey: "772af12ab7d41dc3cd360e150b49383c924b287c2d8a7685d470148b45edca37"
    sha256 arm64_big_sur:  "b591c166cbec1fe3a23691af96fd1ea4b6ddb9e91647f90a204f6cbe772d586b"
    sha256 monterey:       "976c512f27f0fda9e9066e7ab16191491a0d08732ebc19d65421fa4f768e1e0e"
    sha256 big_sur:        "b09ca52ec3ffff6b1ee6463415fe537a0220ca42a754192580e381bf325c35e6"
    sha256 catalina:       "8a55bdf584c7f033270bcf1a99f47432b9729f57c7a4f65af51c3ab131923778"
    sha256 x86_64_linux:   "f9f5e1a67d77b02174bfa5ec72f756b8350840fed3aa0da75c0a16d280e64382"
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@1.1"

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
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    system ENV.cxx, "-o", "test", "test.cpp", "-I#{include}", "-L#{lib}", "-lsasl2"
    assert_equal "20 SGVsbG8sIHdvcmxkIQ==", shell_output("./test")
  end
end
