class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftpmirror.gnu.org/gnu/nettle/nettle-3.10.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/nettle/nettle-3.10.2.tar.gz"
  sha256 "fe9ff51cb1f2abb5e65a6b8c10a92da0ab5ab6eaf26e7fc2b675c45f1fb519b5"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f433c0830169086cae47237fc4fe4b8c71021ec9683006db96e066ff0b883030"
    sha256 cellar: :any,                 arm64_sequoia: "12c88e8d20a6b5161aa759820710b0d793212f46be7d48933e4519198480bd85"
    sha256 cellar: :any,                 arm64_sonoma:  "57596e345b70dbb3debba5d8ba9b90147963f62e25022c2661a3672f25304753"
    sha256 cellar: :any,                 arm64_ventura: "a5f3b6f969357a94626cc52f6e5869a77a0c6fe8bc5ab4fc491ea83ae6986e65"
    sha256 cellar: :any,                 sonoma:        "46f05ed1c965061f176755083b8a14e6f8cfc3543201d95691bc2a4090309152"
    sha256 cellar: :any,                 ventura:       "d82f1ec725dc230650b93facd5d8b5d7f0c2bd6f76b0aa7c6a9d6c3a154e4e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "411e940ef2c87423f8c0ed34427aa5235e0bc702b40943e3564878a62c76d420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff4a7452b4dcf2f1ad266f19f5eb5a29e02b5d1215d4bc46f3d4c4ca4b8e6282"
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
