class Beecrypt < Formula
  desc "C/C++ cryptography library"
  homepage "https://beecrypt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/beecrypt/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz"
  sha256 "286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d"
  license "LGPL-2.1-or-later"
  revision 7

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "19bbdbe37b8f9c59abd5ed8ce3a6c5c0fa4ac50734b445bc9f6a8bb05666c890"
    sha256 cellar: :any,                 arm64_sequoia:  "9d436aea574fc90b56ebdd14da2f08d7484209ddc553ad9a9928bb1b0e2ec28e"
    sha256 cellar: :any,                 arm64_sonoma:   "d90ef1d3a2df7b9ea6981ebf5d3635bbc8a7bf39c1412becdabbf810a499a98f"
    sha256 cellar: :any,                 arm64_ventura:  "3fcce19dcf6e9f7b864752d4a3a44864c774568203710fd7570684dec95c3f65"
    sha256 cellar: :any,                 arm64_monterey: "4acdd6c4d36e63cfdbcee335076ef3a2d037fabcda966692a02301bc3a1c59e1"
    sha256 cellar: :any,                 arm64_big_sur:  "c67f38d1f106232edf5db9ea96b28c9cc240805c3021a41279085e592b3d1a5e"
    sha256 cellar: :any,                 sonoma:         "a06180b00af889242ee74e3588bc423f07d74c220a19c4e8eaff5dbf0deafd29"
    sha256 cellar: :any,                 ventura:        "7657b38fa0f49bc9a8ecf87d84e6f7d6f3a2bee962632d43aea95da5207fe148"
    sha256 cellar: :any,                 monterey:       "76b490b3b3da57df7f5e13032c04ea577fddca473cc34d6274075c1100795ca4"
    sha256 cellar: :any,                 big_sur:        "6a5d3034c4818dbf4332a65bc677edb230d174b2c0f47a4c329960f97400f926"
    sha256 cellar: :any,                 catalina:       "977150a0ff6d0a8739539ad4865bcea9fe68d603d22b86d85d6fdef794d66611"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "63bbd01ef2d5b95098af62252230803004d064aea3a4ab23bc9dd37a3915b7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5940b480e169cfe86dc568bd7a6a527c569797fc7a99155931b0d75798118c7"
  end

  depends_on "libtool" => :build

  # fix build with newer clang, gcc 4.7 (https://bugs.gentoo.org/show_bug.cgi?id=413951)
  patch do
    url "https://sourceforge.net/p/beecrypt/patches/_discuss/thread/93d63cef/5653/attachment/beecrypt-gcc47.patch"
    sha256 "6cb36ae3e8e9c595420379dc535bb5451d0ee60641a38b29a20ca25c7acbc60d"
  end

  # blockmode.c:162:14: error: call to undeclared function 'swapu32';
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  # (https://sourceforge.net/p/beecrypt/patches/13/)
  patch do
    url "https://sourceforge.net/p/beecrypt/patches/13/attachment/beecrypt-4.2.1-c99.patch"
    sha256 "460f25ccd4478e5ec435dc9185b3021518d8b2d65cad2c9c1ee71be804471420"
  end

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-openmp",
                          "--without-java",
                          "--without-python"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "beecrypt/base64.h"
      #include "beecrypt/sha256.h"
      #include <stdio.h>

      int main(void)
      {
        sha256Param hash;
        const byte *string = (byte *) "abc";
        byte digest[32];
        byte *crc;

        sha256Reset(&hash);
        sha256Update(&hash, string, 3);
        sha256Digest(&hash, digest);

        printf("%s\\n", crc = b64crc(digest, 32));

        free(crc);

        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lbeecrypt", "-o", "test"
    assert_match "FJOO", shell_output("./test")
  end
end
