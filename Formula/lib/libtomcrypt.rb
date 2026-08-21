class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/refs/tags/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"
  license "Unlicense"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d82b0b852bedb11cdfe7f28a254014746e93a0328be95bd8e766651bdf0de2ca"
    sha256 cellar: :any, arm64_sequoia: "244b29efcfb583713abea15ac3f2e9db78db69e446590a0fde61f7f95e68312f"
    sha256 cellar: :any, arm64_sonoma:  "1b9d391bb3218384bf0aa828237089788f117de17522aba6f1e97179b01c8090"
    sha256 cellar: :any, sonoma:        "61fe2b3c884b8251113d9ba0ad706d18e9f0e273686b8fafdb98fe9a400be47d"
    sha256 cellar: :any, arm64_linux:   "31a97ee8228a34c6741ceacd7d143587015cdf8ad3265efaf6ef4f76537bb393"
    sha256 cellar: :any, x86_64_linux:  "47a647f60c5017666d2313890c33f0448ab9852adedd5eecedf3b5d2df9603b5"
  end

  depends_on "libtool" => :build
  depends_on "gmp"
  depends_on "libtommath"

  patch do
    url "https://github.com/libtom/libtomcrypt/commit/64d1153e5a515740ab56f39c46baf4cf6991a9d3.patch?full_index=1"
    sha256 "74a7abbe90dd5faf82a139810e13f2978f3a974f57adc463191a0ba1b4378412"
    type :backport
    resolves "CVE-2019-17362"
  end

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
