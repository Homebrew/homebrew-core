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
    sha256 cellar: :any,                 arm64_sonoma:   "9f71fb46be984b3de81084bc400340f93a1e888bb580b3829c522fc43d8c97eb"
    sha256 cellar: :any,                 arm64_ventura:  "1f37a8ac9856c2249251e98da5e75a95bf34fab3dfbf600488c1fabe6dd1d546"
    sha256 cellar: :any,                 arm64_monterey: "6bcd6f6a6afabaea3c17c1d08afbe71dfd1daa0023064035dca0ec0a84980d34"
    sha256 cellar: :any,                 sonoma:         "da2d97ae9b15cc9df4de1098db5492795ed8d10c830c595ae57b8965aef99b9f"
    sha256 cellar: :any,                 ventura:        "04a1f334f8ceca0f56dca4120e4a41892c400b7302c884438a1d242278fded4a"
    sha256 cellar: :any,                 monterey:       "86aeb2c3a76277dd6cb99e697768ad77e2f77fd23063fbb9c3321d3bab51b91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be09ea086a11c50c5717a8cf7e2c2f682bd9a2c9cbdff945c85d4e4bab290116"
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
