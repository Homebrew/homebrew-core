class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz"
  sha256 "26866b1549b00ffd020f188a43c258017fa1c382b3ddadd8201536f72efb05d5"
  license "BSD-3-Clause-Attribution"

  bottle do
    sha256 arm64_monterey: "be512b38bef60c94dfbdfc7724db969547641f0fe1e40440e2d035b22c790852"
    sha256 arm64_big_sur:  "bf65079be801e9e99253d9b2329f42dcf50ce38a76fe0b9cfd0a776651764765"
    sha256 monterey:       "538f672ddbaad8570f71512b9dbf5d1a177cd1ea8e8003ab2e10d38e2a62c039"
    sha256 big_sur:        "383f79bf7d14b883c1b60a1356f3b94e1194ee90ad34b58b722f7ba06b4751d2"
    sha256 catalina:       "15c3df25dde7304adaf9ab246f6387e08029c49bfe4a52726f0d3d1add0452c7"
    sha256 mojave:         "5db405a2496c27205077235e0074767ae35fab10946325f108b425332f6c5c5e"
    sha256 x86_64_linux:   "bcb51adaeb42ea301684ac43c7e7158c2f0998723d9b36e01b9ebc033ce646d0"
  end

  keg_only :provided_by_macos

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
