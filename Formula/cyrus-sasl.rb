class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"

  bottle do
    sha256 arm64_monterey: "ab2db74328cfcf6e6e6d9871dbd9997abf9663f8406f7413eae3297f31df1af5"
    sha256 arm64_big_sur:  "0a68a1a03c26d5c6d3efbab276bb41aef9cfbe2878e0b206a1a4046f326bb9fd"
    sha256 monterey:       "5ae417c006bce921655450e65b34daa21c3c418ee39ae22a9686ffb68b15ae91"
    sha256 big_sur:        "923ba97216a1c61c759b9b3ed961c44ebe8226429898e99785c5efa719b6517e"
    sha256 catalina:       "9af6c7964abcbbad80aa2e9f1203e40f87488c42e5e13e32c74100dc286311ef"
    sha256 x86_64_linux:   "d54ca2a32013569d63be2ce1f2dd92216d47a5e0a096d74561490a429e3b3dbf"
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@1.1"

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
