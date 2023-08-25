class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"
  license "Unlicense"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7331eaecb64d5e144871fa398c93a8666a5d57a9080488910ecc033ee62e9db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "159d50a2adf84043773b8377768218e25fc823902d95fc86f0756c4648096a13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95cc1395317bb6d7a70cf54c951c0a1d023fc4dbd9e8d2962dd70493811c2f08"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbcb985ebf523c66330776eeddc9259ce0ddac8de58331f4c05da18b5eb89cd"
    sha256 cellar: :any_skip_relocation, monterey:       "b53aaf81eda5f5a40ac308cb25c048e37db76339edf3d30065338588c30f3e12"
    sha256 cellar: :any_skip_relocation, big_sur:        "061be8d1fbb275f323042615a2e6b84057fe35b349b21fe87f8a5a961c975b4a"
    sha256 cellar: :any_skip_relocation, catalina:       "2ecaaf5a2d64b92c58498482c3aec69c84c7772ffa5f213ad43010199cd7dec8"
    sha256 cellar: :any_skip_relocation, mojave:         "fbc00f6bcb941ab719a45ca7a52192b6bda774de1e8997c070fbf025bc031f1a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7dda8583b31d847e69406c4eebda576e6de8fd6a3a5461a73c890bcce3162c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8957df3d2611c3979bf19a68c0b0f1cab117c3a434f979b0a6a5cf21f4bc560e"
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
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltomcrypt", "-o", "test"
    assert_equal "passed", shell_output("./test").strip
  end
end
