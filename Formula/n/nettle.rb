class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.9.1.tar.gz"
  sha256 "ccfeff981b0ca71bbd6fbcb054f407c60ffb644389a5be80d6716d5b550c6ce3"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8421b1b1c642a639028f71f23939bdb56a2a8d331f3f3f1cac1bd8866d540d4d"
    sha256 cellar: :any,                 arm64_ventura:  "751e140ceac7711c462f1c05d74297c79f0abea26666f974370886c01d7bec83"
    sha256 cellar: :any,                 arm64_monterey: "0438f593bb82ef4bfbe1c3ebba3e42dd168f031674975832823f45b6b528a997"
    sha256 cellar: :any,                 arm64_big_sur:  "0b2001b44f417826e8463d83ce936105af71022cbe9f1e3ca0288b4389e6c460"
    sha256 cellar: :any,                 sonoma:         "1ca027209066ee94bd36364805879ff4e0f62f55b9c2f4d5ed20605d00eb3dda"
    sha256 cellar: :any,                 ventura:        "180c6997e8df4c9e686250ef8388fa61bfde55ccd1f64c093122c10f18ce430f"
    sha256 cellar: :any,                 monterey:       "8125044368a0ca002deed4578d868d9a90dd8532403eaad9237be8ae3b8f4ef5"
    sha256 cellar: :any,                 big_sur:        "3892e22ccbf2c0305c33445b591a398ec9df758cb3589a4d872ecf266f737831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cb9f1c702bee6f67ef0a3d4c075b6d6b0dddf54853120a33272ce704d5a6d7"
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
