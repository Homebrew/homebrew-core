class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.28/cyrus-sasl-2.1.28.tar.gz"
  sha256 "7ccfc6abd01ed67c1a0924b353e526f1b766b21f42d4562ee635a8ebfc5bb38c"
  license "BSD-3-Clause-Attribution"
  revision 2

  bottle do
    sha256 arm64_tahoe:    "17e620e6b3ab58620c3b6d2f06eca63d45ed857243b19f67b607ed144a68acd0"
    sha256 arm64_sequoia:  "da30f7a99a52b40b17ca249fe2a518a556aba23a8bec5cca7b1c5b4dac577239"
    sha256 arm64_sonoma:   "8cb90c0b643e0626e2dc31287654b45a6bbda61a2077879a8d29a47b793ded55"
    sha256 arm64_ventura:  "a842b727db6d438e03d495a94f5dd63e2f7a6634809cbe3b621195e180d56f64"
    sha256 arm64_monterey: "ac7a6ac5d43047181241674de948c84e57fd26e2ae070dcb2bad243f57ffb0db"
    sha256 arm64_big_sur:  "dfa2cf772e87d85128b4ae58ed7f6d85ff078d673e5a49496fcad0b17af7b3e4"
    sha256 sonoma:         "5112a83906ea31b699c5a1ee149729298c160585cdc1c65702a81b6de5318193"
    sha256 ventura:        "b0ad0b2d1e4394623692dd7c32014677dcc364c32bae2a9a27913485ca07f91d"
    sha256 monterey:       "1e9df5f50cc72d9561b8f8985d3a7520db0de782c45a8d32530c1cd5bf9e9db5"
    sha256 big_sur:        "abf53f0d9551994232096d88a1e312c50ec2f9465730e734c3af75db46016103"
    sha256 arm64_linux:    "66658e5a01892c2952754447404b14f73a888c1cd5b97dbed3c6244dc4d62a2a"
    sha256 x86_64_linux:   "f1bc6d528c1c0e53c2eecb599e5127070654a7bdfb9acb0232cfd08bfaf38efd"
  end

  keg_only :provided_by_macos

  depends_on "krb5"
  depends_on "openssl@3"

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
