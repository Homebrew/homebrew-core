class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://cryptopp.com/"
  url "https://cryptopp.com/cryptopp890.zip"
  mirror "https://github.com/weidai11/cryptopp/releases/download/CRYPTOPP_8_9_0/cryptopp890.zip"
  version "8.9.0"
  sha256 "4cc0ccc324625b80b695fcd3dee63a66f1a460d3e51b71640cdbfc4cd1a3779c"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "d6cdbe84008d6489b21fed34813dbc6b349c90c52cc7573f7bf5b670b3290d3c"
    sha256 cellar: :any,                 arm64_sonoma:   "272e8028bcdf871a7c35d6590af87d3520aa9d1c053d2d5253dec85656c1b19d"
    sha256 cellar: :any,                 arm64_ventura:  "d4a8d3ba690a9762d7fdd84a048b8e73ca14a44c52ee82d40b309799c5603890"
    sha256 cellar: :any,                 arm64_monterey: "44322c46519ccadfb08e746e54b71a7183ae5daa348a04f2a0c8399f13409f59"
    sha256 cellar: :any,                 sonoma:         "d9b7900ca928fd39e568a259e6f1f4e093d5ae7e33debbd0f94c6e6d7e8578ad"
    sha256 cellar: :any,                 ventura:        "9703073429f04a5b3e2e0f1ae3adb4419ecc87c520471d4f19ba45b1fd45c68e"
    sha256 cellar: :any,                 monterey:       "a8fbbbb8ab93c348d4d6258a7d2423843bb1a04a465ac1eac85df26e46eb9788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6404ced52f843fd29dc3a495ff3706c4040641597ae50e1cd58e19e1d915777"
  end

  def install
    ENV.cxx11
    system "make", "all", "libcryptopp.pc", "PREFIX=#{prefix}"
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
