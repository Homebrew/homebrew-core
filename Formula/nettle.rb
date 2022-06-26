class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.8.tar.gz"
  sha256 "7576c68481c198f644b08c160d1a4850ba9449e308069455b5213319f234e8e6"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b61086fc1616d167da639ff13fa27f69725d4f13c355dbf232833c0b914d8bf"
    sha256 cellar: :any,                 arm64_big_sur:  "36a157d168f8d95ccb4bb193a97def7960796e2fa3b480db69f1ead8d8c6a7aa"
    sha256 cellar: :any,                 monterey:       "222e74d0fd546c335fda1fa1dab2fb14b05fd7947aafd2a1435f17601ec9c283"
    sha256 cellar: :any,                 big_sur:        "01e96077ec7b8810e209dba7916917d4398533e17652480bb740542c8a46bd30"
    sha256 cellar: :any,                 catalina:       "480c2fa59555d18bfcfb48fe8dcae7f99c4b3f9efe464d0781cd9cf47adcb878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a8eb68fde965bc658f053a0a4b8172e4b54a1951e83cf31b50c1188ff1470c"
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
