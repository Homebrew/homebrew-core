class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"
  license "Unlicense"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "373529c12106df1c9d42ee7b18397378695aab805e3f615578c3c4658773cd23"
    sha256 cellar: :any,                 arm64_sequoia:  "3572bea96ce1e844e910c3e5ec392de56a789a581dfb1860169c7c30d94359fb"
    sha256 cellar: :any,                 arm64_sonoma:   "2743b90014a43cb92757b4b4be23cbcd231d821702e680f15180513cf3030af1"
    sha256 cellar: :any,                 arm64_ventura:  "d1f46d9db67ffb4b33d3419aba1e6e870a9a802b83df1d2aa15c4e6fd32f336a"
    sha256 cellar: :any,                 arm64_monterey: "59af3e5207ab67b8a0d16f2014516198a299b3acec8181a3b0779ce4161b73ed"
    sha256 cellar: :any,                 arm64_big_sur:  "b44213ca06c3cd177563cd22daf8cbb912fca0dfd754c69e86851af5a0b35cc3"
    sha256 cellar: :any,                 sonoma:         "6b0591e8b409b44cc5cd7eeca0e4562b573b8e2eb4d07bcf5332a7085e107ab4"
    sha256 cellar: :any,                 ventura:        "5fd60ad0923f5288a69d6dfd21b240bf8de82b261567992a1ff064484130a25e"
    sha256 cellar: :any,                 monterey:       "90264e0441e4796b20e7c13dca05149e582f77187cea53c333f8839417992bd0"
    sha256 cellar: :any,                 big_sur:        "53181a23459d9a55cdcf9f0283310d3b6ceb9049239c0a223e74202481de7300"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7118ecc3f9a3986ee0fa6fd49e54d844092c5ead298e59dd6b9adb6a21b37653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27294aefd23c971546ba62354ee81327a45f84ae4bf5e953c0397def99dfce51"
  end

  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "libtommath"

  def install
    ENV.append_to_cflags "-DUSE_GMP -DGMP_DESC -DUSE_LTM -DLTM_DESC"
    ENV.append "EXTRALIBS", "-lgmp -ltommath"
    system "make", "-f", "makefile.shared"
    system "make", "-f", "makefile.shared", "test"
    system "./test"
    system "make", "-f", "makefile.shared", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <string.h>
      #include <inttypes.h>
      #include <tomcrypt.h>

      #define AES128_KEY_SIZE 16
      #define AES_BLOCK_SIZE  16

      static const uint8_t key[AES128_KEY_SIZE] =
          {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};
      static const uint8_t plain[AES_BLOCK_SIZE] =
          {0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB, 0xCC, 0xDD, 0xEE, 0xFF};
      static const uint8_t cipher[AES_BLOCK_SIZE] =
          {0x69, 0xC4, 0xE0, 0xD8, 0x6A, 0x7B, 0x04, 0x30, 0xD8, 0xCD, 0xB7, 0x80, 0x70, 0xB4, 0xC5, 0x5A};

      int main(int argc, char* argv [])
      {
          symmetric_key skey;
          uint8_t encrypted[AES_BLOCK_SIZE];
          uint8_t decrypted[AES_BLOCK_SIZE];

          register_all_ciphers();
          if (aes_setup(key, AES128_KEY_SIZE, 0, &skey) == CRYPT_OK &&
              aes_ecb_encrypt(plain, encrypted, &skey) == CRYPT_OK &&
              memcmp(encrypted, cipher, AES_BLOCK_SIZE) == 0 &&
              aes_ecb_decrypt(encrypted, decrypted, &skey) == CRYPT_OK &&
              memcmp(decrypted, plain, AES_BLOCK_SIZE) == 0)
          {
              printf("passed\\n");
              return EXIT_SUCCESS;
          }
          else {
              printf("failed\\n");
              return EXIT_FAILURE;
          }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltomcrypt", "-o", "test"
    assert_equal "passed", shell_output("./test").strip
  end
end
