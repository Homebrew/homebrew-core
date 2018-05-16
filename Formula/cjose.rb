class Cjose < Formula
  desc "C library implementing Javascript Object Signing and Encryption (JOSE)"
  homepage "https://github.com/cisco/cjose/"
  url "https://github.com/cisco/cjose/archive/0.6.1.tar.gz"
  sha256 "208eaa0fa616b44a71d8aa155c40b14c7c9d0fa2bb91d1408824520d2fc1b4dd"

  bottle do
    cellar :any
    sha256 "09e502a456548467efefce44a61254234bfa5d50195619c8fc2613a1f630746b" => :high_sierra
    sha256 "6211036e0120bc6980767783f4f27cb15928f07da237772e091aa934a2c6f85b" => :sierra
    sha256 "f8dd2b03f6c41981f79f993504c3643ed0ae7983420c374dcd52fc03763580fc" => :el_capitan
  end

  depends_on "jansson"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
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
