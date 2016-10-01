class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftpmirror.gnu.org/nettle/nettle-3.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz"
  sha256 "46942627d5d0ca11720fec18d81fc38f7ef837ea4197c1f630e71ce0d470b11e"

  bottle do
    cellar :any
    sha256 "c111158ee75fde15a6b5a0417416f62358dfb0d06fcab0311b1d9d4849df5fa2" => :sierra
    sha256 "b23a2c67db98f807d240fc581ee87b4eb4284b1eabda8d38e09b8723eb6b4b62" => :el_capitan
    sha256 "fa2a4eb958c0f9a1ec019264e31c0c98a08c9f204f146458ca62a43e5c3029a0" => :yosemite
  end

  depends_on "gmp"

  def install
    # OS X doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lnettle", "-o", "test"
    system "./test"
  end
end
