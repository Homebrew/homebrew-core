class NettleAT3 < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftpmirror.gnu.org/gnu/nettle/nettle-3.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.10.2.tar.gz"
  sha256 "fe9ff51cb1f2abb5e65a6b8c10a92da0ab5ab6eaf26e7fc2b675c45f1fb519b5"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?nettle[._-]v?(3(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c72342029b69116096dc2de6b67106706c3fc0b0d85cfb1090e3e4c4b01cc147"
    sha256 cellar: :any,                 arm64_sequoia: "4af74cceda18a0684e64e1c9681a9f5b55ddcd49c6530ee50cdc320eaa2ec0b7"
    sha256 cellar: :any,                 arm64_sonoma:  "b588f0f1bf01b311ecbb65bfa235619e0c29b5a22192dc8215326dcb73e5af8e"
    sha256 cellar: :any,                 sonoma:        "50b37df2b10bf62e7119a5b784e99adcb401e91d9c436beaec9ac734b5e21f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcb5a9ea8b1a45768d2852ed3675e10146fc6686733419135d8a4c65a8bfd95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "810d4174773f0498fc797c535184f7f1c430bd0a129a7d71bf68018eb3358f95"
  end

  keg_only :versioned_formula

  depends_on "gmp"

  uses_from_macos "m4" => :build

  def install
    system "./configure", "--enable-shared", *std_configure_args
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
        sha1_digest(&ctx, SHA1_DIGEST_SIZE, digest);

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
