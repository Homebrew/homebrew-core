class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.4.tar.gz"
  sha256 "ae7a42df026550b85daca8389b6a60ba6313b0567f374392e54918588a411e94"

  bottle do
    cellar :any
    sha256 "d5f8ed7557a26c0a2a34031b10a34b12c0c8f518782ed1d17fb13930ecfcdf45" => :high_sierra
    sha256 "d03831c4b2217900338b2316bf73b0074271b0007c2aaaa8fddf606a5f71d7ee" => :sierra
    sha256 "a8f3221e9f9281d5493e09b9cbbddc7038de24fbb6375e0255294cae822b866a" => :el_capitan
  end

  depends_on "gmp"

  def install
    # macOS doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
    system "make", "check"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    system ENV.cc, "test.c", "-L#{lib}", "-lnettle", "-o", "test"
    system "./test"
  end
end
