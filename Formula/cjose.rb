class Cjose < Formula
  desc "C library implementing Javascript Object Signing and Encryption (JOSE)"
  homepage "https://github.com/cisco/cjose"
  url "https://github.com/cisco/cjose/archive/0.6.1.tar.gz"
  sha256 "208eaa0fa616b44a71d8aa155c40b14c7c9d0fa2bb91d1408824520d2fc1b4dd"

  depends_on "jansson"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cjose/version.h>
      #include <assert.h>
      #include <string.h>
      int main()
      {
        const char *version = cjose_version();
        assert(strcmp(version, CJOSE_VERSION) == 0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcjose", "-o", "test"
    system "./test"
  end
end
