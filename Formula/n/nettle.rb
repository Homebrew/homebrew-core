class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.10.tar.gz"
  sha256 "b4c518adb174e484cb4acea54118f02380c7133771e7e9beb98a0787194ee47c"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8dd077a363c69d5d31968c7cfbc79dd5ec856b58957bc081f6f38632d59029cf"
    sha256 cellar: :any,                 arm64_sonoma:   "79f26a53dfc0202c437153961d441a8793fb651d1eb61930f1558d139cdfd99a"
    sha256 cellar: :any,                 arm64_ventura:  "cc13fe4481bb5c606b811561da643eace9e0da7f30de62ced74811659b8bb41d"
    sha256 cellar: :any,                 arm64_monterey: "8be68cdd3cc9b2df465840fd843b50e6bb10fda11c5711e50f002bb31267cb1f"
    sha256 cellar: :any,                 sonoma:         "2638a7bfcca9dbaa6a935f7ae80aed9d3f1064b64189a0f3364f4b20f4a9d341"
    sha256 cellar: :any,                 ventura:        "372ad197aa7857e6ac863471ae301cdc13f313b34397309b7e1a27ca5b104ba0"
    sha256 cellar: :any,                 monterey:       "c04364b7c2beb64a5c7d2ba645749e07e256b7c5d30968cfa2722c289be24542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05101c1f60cf7b267464af60a6814404e32691af7630e4ea23ed5b85ae1257a7"
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
