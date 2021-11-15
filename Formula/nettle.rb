class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.7.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.7.3.tar.gz"
  sha256 "661f5eb03f048a3b924c3a8ad2515d4068e40f67e774e8a26827658007e3bcf0"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c47b2e4721e5c8347194e3dad066bf00fc6b5d28cb4082f53535dba76a1ed658"
    sha256 cellar: :any,                 arm64_big_sur:  "3cd41002e6358b07ca506ed09fb07473d61c1c2717b630f8d708c74ab5d06704"
    sha256 cellar: :any,                 monterey:       "dccc8b4c4e02bcd485c1558ec1f01ca4c591a502b464629dc2e514add894b64b"
    sha256 cellar: :any,                 big_sur:        "80fa0a047c3d08ccb47c8820a566d187365e8ea75e0cdf903ef0653d3aa3bb67"
    sha256 cellar: :any,                 catalina:       "f1f1c41bf3dadabc748a34bba26b8771e4e36ae0815be4a83d1d317d90fa3c2e"
    sha256 cellar: :any,                 mojave:         "f7900666b8d57164a5e770008390ea3fe2c519941e3f28daba9ef91dad4e5e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7c56819e2bc18baf900853311685108aab2cda8fc4963ca095ba893235ef1cb"
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
