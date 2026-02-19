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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "53bc84217451c7ae2716346f62519e9b100409180949df14259c0159c04166e5"
    sha256 cellar: :any,                 arm64_sequoia: "bdd7bfce252e592dc412d8b735a4fac2c9d5868607abbf9253a581c288c21dd9"
    sha256 cellar: :any,                 arm64_sonoma:  "cb1da0fe0980b17d853b47b0c9fb35d1f3706170054535b1778a4ae0239a2e59"
    sha256 cellar: :any,                 arm64_ventura: "2d9ecda6fcc0053372db8935aeb739998802bc0023e667f6df8836b15385b848"
    sha256 cellar: :any,                 sonoma:        "7b027167f9f423f7c74506cfc69bdf95a6bf81a43a352e779763dda2dc6275c8"
    sha256 cellar: :any,                 ventura:       "8ce970a2b184c1e9f086a267e076218f8b7d59c5675bdbe8660e7ca47526a0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec942ec0a779138e44ad756701c4d75a2ad6cc2c0aba9b6778503886c3ea57fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f784742a258c83ac87f661ea435fbe4ec565c57dc517f8dca6af6f549981c5f"
  end

  def install
    ENV.cxx11
    ENV.runtime_cpu_detection # https://github.com/weidai11/cryptopp/blob/master/cpu.h

    system "make", "all", "libcryptopp.pc", "PREFIX=#{prefix}"
    system "make", "test"
    system "make", "install-lib", "PREFIX=#{prefix}"
  end

  test do
    # Test program modified from:
    #   https://www.cryptopp.com/wiki/Advanced_Encryption_Standard
    (testpath/"test.cc").write <<~CPP
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
    CPP
    system ENV.cxx, "-std=c++11", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lcryptopp", "-o", "test"
    system "./test"
  end
end
