class CyrusSasl < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://github.com/cyrusimap/cyrus-sasl/releases/download/cyrus-sasl-2.1.27/cyrus-sasl-2.1.27.tar.gz"
  sha256 "26866b1549b00ffd020f188a43c258017fa1c382b3ddadd8201536f72efb05d5"
  license "BSD-3-Clause-Attribution"
  revision 1

  bottle do
    sha256 arm64_monterey: "231a048fc10dff729b35fd1c88899ed2dc8c277d58100ecea126c5b2d5c44026"
    sha256 arm64_big_sur:  "23b9e07801f2fc926b4ace843f532466af846fa0a87665ad1454e08264323c28"
    sha256 monterey:       "720e07e870a3d127e5017597057564a5bdb870b23d2089cb062a438be1416ed5"
    sha256 big_sur:        "e78c9a94869d5a2819f1a33ebb990242e08ddd9a96194875d3017f5c0e79d7a9"
    sha256 catalina:       "c4cfe573982abf9b9905071c048e4b7fd88208539ebcd94d1e92122b63fed1dd"
    sha256 x86_64_linux:   "151a2bcbebd3148b76e584de7e6f45f31ce1d9bd25ea816d7723efc292c2c098"
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
