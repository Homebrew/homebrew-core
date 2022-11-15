class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.8.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.8.1.tar.gz"
  sha256 "364f3e2b77cd7dcde83fd7c45219c834e54b0c75e428b6f894a23d12dd41cbfe"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4d691aa1139d55ac8b1fc72ffc11d2374fa74fb591bad3839af009a52758d011"
    sha256 cellar: :any,                 arm64_monterey: "f2fa03ad5664fdcf8475c1490a22f66d26056779911fd92ae2cb0d36998319a4"
    sha256 cellar: :any,                 arm64_big_sur:  "6b169f8f81ec4dae1a1137f7d8738a4acdb24806c1057039791bb58dc9fb67d8"
    sha256 cellar: :any,                 ventura:        "6ad1de919308d5853d012287df427ec3b669981d4459a09ef83c8d36e53e8154"
    sha256 cellar: :any,                 monterey:       "19eca950c962860d44093db86226b8a07ca045973c15f7d3b0de2acd1cfad3da"
    sha256 cellar: :any,                 big_sur:        "48493dc5881e45b030b1f39d379fe70d6d8707063766c0f223e20e190d8de4ba"
    sha256 cellar: :any,                 catalina:       "185a433efd966756372f46bb0669eaaac9883c6f9a149d2d7e0ed33df661d1fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1901826420ae92f7998068673ec444d32550618f38ad1c074acf68be16b9b056"
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
