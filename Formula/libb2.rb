class Libb2 < Formula
  desc "Secure hashing function"
  homepage "https://blake2.net/"
  url "https://github.com/BLAKE2/libb2/releases/download/v0.98.1/libb2-0.98.1.tar.gz"
  sha256 "53626fddce753c454a3fea581cbbc7fe9bbcf0bc70416d48fdbbf5d87ef6c72e"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6c9ffaf08fde8879febf2998a289d6e9bfa505ed29cdf5f4c41d52a632c11f1e"
    sha256 cellar: :any,                 arm64_monterey: "fa45f83dfa716f0f69bb395eeb3016c9cc3223c975b64bed5544304e0eb4cd2c"
    sha256 cellar: :any,                 arm64_big_sur:  "7713b483f3474a3531c5830bbc8de7ad1903989e55e5da3ff5bfd85e87c5c045"
    sha256 cellar: :any,                 ventura:        "cc245560dda3edceb402702f3066f6aeb5c526e93dbb2a1e06bc02139d6154c2"
    sha256 cellar: :any,                 monterey:       "f526645f4114ef85c577d611383bb7e0acdc2697719caa73cd8677260b516a25"
    sha256 cellar: :any,                 big_sur:        "7e21b980288ef9449cb44a4b2d33a0d0772b0482165c9ee5f12d42b71b357bc0"
    sha256 cellar: :any,                 catalina:       "fb9f331b6c556a09558cf8098c3934f3f9196c3076e2511fd6ed816439fb8936"
    sha256 cellar: :any,                 mojave:         "bbd333a0a89e6a38445aba0170b14b516edad300c30d6f4239b66a130c446959"
    sha256 cellar: :any,                 high_sierra:    "6e9156db268cea377f7050c4e9ebf1ee3065fef76a11c40e03e700a23b1bef36"
    sha256 cellar: :any,                 sierra:         "9b909b878c01b5bb3284ba4d0937352e0df54b27e491fa796dfb6d3e67f989a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e12bfdb9ca31174e1f644bd68f89f7de0354b7661569b59cde6c8a6de2d8a24"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # SSE detection is broken on arm64 macos
    # https://github.com/BLAKE2/libb2/issues/36
    extra_args = []
    extra_args << "--enable-fat" unless Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          *extra_args
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
