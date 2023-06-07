class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.9.tar.gz"
  sha256 "0ee7adf5a7201610bb7fe0acbb7c9b3be83be44904dd35ebbcd965cd896bfeaa"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1eede72be5e777dcaf56bedd3d1e3025721802a6bb76ddadfaa7e00687473d29"
    sha256 cellar: :any,                 arm64_monterey: "dd7c688e3670f0bd70de95986940863c36d6520b1367b4644a5107d10a2011db"
    sha256 cellar: :any,                 arm64_big_sur:  "9f2ac8a6f7c3e59567963fb58b54cdb356398dcc5ca7ded600c4e69fd2b9f3c5"
    sha256 cellar: :any,                 ventura:        "ce695fb7726b6e23ffa11f986200e57beb6491dafaee565b425e1bd6a6df99e7"
    sha256 cellar: :any,                 monterey:       "e89e182fa226751c0dccc50f1c879a406afaf8d2a87a9bc0dfa2c922052fe0f8"
    sha256 cellar: :any,                 big_sur:        "96c9f8a3e4492142b5a1945aa61fecc237340fd0b828bdfaaebf1556b100d541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "178762434a32894286c1ee1b3f7221dd82a198a7bb60343b30c750ddbfa0a848"
  end

  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    system "./configure", *std_configure_args, "--enable-shared"
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
