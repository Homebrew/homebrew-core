class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.7.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.7.1.tar.gz"
  sha256 "156621427c7b00a75ff9b34b770b95d34f80ef7a55c3407de94b16cbf436c42e"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3efe8eae1e8f9c3d2e05ae28eb1b1b2cb6d31fe1ed0116979e5df6fda01a60b0"
    sha256 cellar: :any, big_sur:       "902f1d7ccbb934172e0274d46ac98b38a528bfc3d810da05e6eb5f1d5a13a0b1"
    sha256 cellar: :any, catalina:      "9504cb3a8dc7a70dc118635d5af2b79bd1dbda75db8ecc17ef6988b50933d633"
    sha256 cellar: :any, mojave:        "a7fb32b7bbc8b6c010f850ac9f2a7016a32ed7f645b2d4887e30a8cd7b2b2fe4"
  end

  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    # The LLVM shipped with Xcode/CLT 10+ compiles binaries/libraries with
    # ___chkstk_darwin, which upsets nettle's expected symbol check.
    # https://github.com/Homebrew/homebrew-core/issues/28817#issuecomment-396762855
    # https://lists.lysator.liu.se/pipermail/nettle-bugs/2018/007300.html
    if DevelopmentTools.clang_build_version >= 1000
      inreplace "testsuite/symbols-test", "get_pc_thunk",
                                          "get_pc_thunk|(_*chkstk_darwin)"
    end

    args = []
    args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          *args
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
