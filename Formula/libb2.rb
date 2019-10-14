class Libb2 < Formula
  desc "Secure hashing function"
  homepage "https://blake2.net/"
  url "https://github.com/BLAKE2/libb2/releases/download/v0.98.1/libb2-0.98.1.tar.gz"
  sha256 "53626fddce753c454a3fea581cbbc7fe9bbcf0bc70416d48fdbbf5d87ef6c72e"

  bottle do
    cellar :any
    sha256 "fb9f331b6c556a09558cf8098c3934f3f9196c3076e2511fd6ed816439fb8936" => :catalina
    sha256 "bbd333a0a89e6a38445aba0170b14b516edad300c30d6f4239b66a130c446959" => :mojave
    sha256 "6e9156db268cea377f7050c4e9ebf1ee3065fef76a11c40e03e700a23b1bef36" => :high_sierra
    sha256 "9b909b878c01b5bb3284ba4d0937352e0df54b27e491fa796dfb6d3e67f989a1" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-fat",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"blake2test.c").write <<~EOS
      #include <blake2.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
          uint8_t out[64];
          uint8_t expected[64] =
          {
            0xb2, 0x02, 0xb4, 0x77, 0xa7, 0x97, 0xe9, 0x84, 0xe6, 0xa2, 0xb9, 0x76,
            0xca, 0x4c, 0xb7, 0xd3, 0x94, 0x40, 0x04, 0xb3, 0xef, 0x6c, 0xde, 0x80,
            0x34, 0x1c, 0x78, 0x53, 0xa2, 0xdd, 0x7e, 0x2f, 0x9e, 0x08, 0xcd, 0xa6,
            0xd7, 0x37, 0x28, 0x12, 0xcf, 0x75, 0xe8, 0xc7, 0x74, 0x1f, 0xb6, 0x56,
            0xce, 0xc3, 0xa1, 0x19, 0x77, 0x2e, 0x2e, 0x71, 0x5c, 0xeb, 0xc7, 0x64,
            0x33, 0xfa, 0xfd, 0x4d
          };
          int res = blake2b(out, "blake2", "blake2", 64, 6, 6);
          if (res == 0) {
            if (memcmp(out, expected, 64) == 0) {
              return 0;
            } else {
              return 1;
            }
          } else {
            return 1;
          }
      }
    EOS
    system ENV.cc, "blake2test.c", "-L#{lib}", "-lb2", "-o", "b2test"
    system "./b2test"
  end
end
