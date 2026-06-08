class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftpmirror.gnu.org/gnu/nettle/nettle-4.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-4.0.tar.gz"
  sha256 "3addbc00da01846b232fb3bc453538ea5468da43033f21bb345cb1e9073f5094"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]
  compatibility_version 2

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ba11eb261bc502c28c9cd695f8354306d0a31cb1e55c3d3f1568e051293a0f10"
    sha256 cellar: :any,                 arm64_sequoia: "01050aa13ce3825fc1b81f1a3c5994a165301b9d5223a9fb9015d122bde5ca3e"
    sha256 cellar: :any,                 arm64_sonoma:  "ffcf86d94ce0ee31890cfc5e2debfba3f4ab9125a507ff21cfa557acac70087e"
    sha256 cellar: :any,                 sonoma:        "2830a19a06e2995fc7a19ecd7c14d3bc87e9362fb9c52d2489582246f256662d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150e9b064e29adf5e75acedbe9de51af5befbd2a7d9986e8ec578646a0af6b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c75ac3e75c761b4553312c4ffc12c31eb1757b5ec3e85ce75adc9524337302"
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
    (testpath/"test.c").write <<~C
      #include <nettle/sha1.h>
      #include <stdio.h>

      int main()
      {
        struct sha1_ctx ctx;
        uint8_t digest[SHA1_DIGEST_SIZE];
        unsigned i;

        sha1_init(&ctx);
        sha1_update(&ctx, 4, "test");
        sha1_digest(&ctx, digest);

        printf("SHA1(test)=");

        for (i = 0; i<SHA1_DIGEST_SIZE; i++)
          printf("%02x", digest[i]);

        printf("\\n");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnettle", "-o", "test"
    system "./test"
  end
end
