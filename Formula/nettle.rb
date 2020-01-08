class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.4.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.4.1.tar.gz"
  sha256 "f941cf1535cd5d1819be5ccae5babef01f6db611f9b5a777bae9c7604b8a92ad"

  bottle do
    cellar :any
    sha256 "338da826ad5127a98f1658c01f2bd128aa9383b3581c9beebc0f0ebc88b0d089" => :catalina
    sha256 "9e7f78a4cc96ca57f75ca1d37cc12c11655b7e0aa7109da4becd0408a1e2ed6b" => :mojave
    sha256 "4327e8e4c4760653113f0bc4a7b0bada37b2d820f6c3ba759832e59ed553cb9a" => :high_sierra
    sha256 "4624e3b0964d695408cf45330bab8cda2536002834f96202f7a37007407123fd" => :sierra
  end

  depends_on "gmp"

  def install
    # macOS doesn't use .so libs. Emailed upstream 04/02/2016.
    inreplace "testsuite/dlopen-test.c", "libnettle.so", "libnettle.dylib"

    # The LLVM shipped with Xcode/CLT 10+ compiles binaries/libraries with
    # ___chkstk_darwin, which upsets nettle's expected symbol check.
    # https://github.com/Homebrew/homebrew-core/issues/28817#issuecomment-396762855
    # https://lists.lysator.liu.se/pipermail/nettle-bugs/2018/007300.html
    if DevelopmentTools.clang_build_version >= 1000
      inreplace "testsuite/symbols-test", "get_pc_thunk",
                                          "get_pc_thunk|(_*chkstk_darwin)"
    end

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
