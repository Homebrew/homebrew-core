class Nettle < Formula
  desc "Low-level cryptographic library"
  homepage "https://www.lysator.liu.se/~nisse/nettle/"
  url "https://ftp.gnu.org/gnu/nettle/nettle-3.10.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/nettle/nettle-3.10.1.tar.gz"
  sha256 "b0fcdd7fc0cdea6e80dcf1dd85ba794af0d5b4a57e26397eee3bc193272d9132"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df8b22b1a4deeafeae7f4afe13cd7403a3700c7779715916c43a45fad7ca5aaa"
    sha256 cellar: :any,                 arm64_sonoma:  "87c602d6924a588d6fb7164f714cc3f29a63c6edd83ffb6b437faccc263133b8"
    sha256 cellar: :any,                 arm64_ventura: "10243a9374699001a49008a6856904821a75e9a644ab49b9c2ac66c22ac31aa5"
    sha256 cellar: :any,                 sonoma:        "6e502038a53a443864edeb85e3423986ec5c383c0fd8c3061ba95af71d369744"
    sha256 cellar: :any,                 ventura:       "7d924af8b68729fbd75a279173b03da71219ee53c8c660198360dd4c8c0cde59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56925c4200b245efa3e7587be30ef3f4881a5d8ad789e1d1d6edf810bb793d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aeaad58a40d92dc7e23b80d7b1663ece6d7a46d9b919a52c4553cbed9a9e214"
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
