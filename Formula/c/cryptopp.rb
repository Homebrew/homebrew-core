class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://cryptopp.com/"
  url "https://cryptopp.com/cryptopp880.zip"
  mirror "https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_8_0/cryptopp880.zip"
  version "8.8.0"
  sha256 "ace1c7b010a409eba5e86c4fd5a8845c43a6ac39bb6110e64ca5d7fea08583f4"
  license all_of: [:public_domain, "BSL-1.0"]
  head "https://github.com/weidai11/cryptopp.git", branch: "master"

  livecheck do
    url :head
    regex(/^CRYPTOPP[._-]V?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7d03053c9802c0533b277549f9a4173ca985ac065076d5ec1846673400665177"
    sha256 cellar: :any,                 arm64_monterey: "2e3fa5188ca17a91484735723c37272f56c26f14f71d8328b3d10ebab5ca14d8"
    sha256 cellar: :any,                 arm64_big_sur:  "a6d82bdb7e7fb9422abfb954c2008c014c819552304b3a3dfa944ca5a73b8eaa"
    sha256 cellar: :any,                 ventura:        "67ef7d471cc2702a3d113167ab62073dd413f408f1461e11fd18c25347293f04"
    sha256 cellar: :any,                 monterey:       "013ce1ca4a1a3ccbe379794214bf9b9a433e77d4a6f85870acfdaa258e1d5ec1"
    sha256 cellar: :any,                 big_sur:        "5be44e1e27595782ceac99eb8a36c43b567d9eb8db2116e5702aaaecfe9073f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebdd057a75c85f69868a0d64b3da7b0f4514856f889ec959ff67408e2c3431e1"
  end

  def install
    ENV.cxx11
    system "make", "all", "libcryptopp.pc"
    system "make", "test"
    system "make", "install-lib", "PREFIX=#{prefix}"
  end

  test do
    # Test program modified from:
    #   https://www.cryptopp.com/wiki/Advanced_Encryption_Standard
    (testpath/"test.cc").write <<~EOS
      #ifdef NDEBUG
      #undef NDEBUG
      #endif
      #include <cassert>
      #include <iostream>
      #include <string>

      #include <cryptopp/cryptlib.h>
      #include <cryptopp/modes.h>
      #include <cryptopp/osrng.h>
      #include <cryptopp/rijndael.h>

      int main(int argc, char *argv[]) {
        using namespace CryptoPP;

        AutoSeededRandomPool prng;

        SecByteBlock key(AES::DEFAULT_KEYLENGTH);
        SecByteBlock iv(AES::BLOCKSIZE);

        prng.GenerateBlock(key, key.size());
        prng.GenerateBlock(iv, iv.size());

        std::string plain = "Hello, Homebrew!";
        std::string cipher;
        std::string recovered;

        try {
          CBC_Mode<AES>::Encryption e;
          e.SetKeyWithIV(key, key.size(), iv);
          StringSource s(plain, true,
              new StreamTransformationFilter(e, new StringSink(cipher)));
        } catch (const Exception &e) {
          std::cerr << e.what() << std::endl;
          exit(1);
        }

        try {
          CBC_Mode<AES>::Decryption d;
          d.SetKeyWithIV(key, key.size(), iv);
          StringSource s(cipher, true,
              new StreamTransformationFilter(d, new StringSink(recovered)));
        } catch (const Exception &e) {
          std::cerr << e.what() << std::endl;
          exit(1);
        }

        assert(plain == recovered);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lcryptopp", "-o", "test"
    system "./test"
  end
end
