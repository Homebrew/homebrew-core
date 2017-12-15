class Cryptopp < Formula
  desc "Free C++ class library of cryptographic schemes"
  homepage "https://www.cryptopp.com/"
  url "https://github.com/weidai11/cryptopp/archive/CRYPTOPP_5_6_5.tar.gz"
  sha256 "79fd5514b3b191a1c6d934cd989d5e058f4726a72a3dad2444bd1274a6aae686"

  # https://cryptopp.com/wiki/Config.h#Options_and_Defines
  bottle :disable, "Library and clients must be built on the same microarchitecture"

  def install
    system "make", "shared", "all", "CXX=#{ENV.cxx}"
    system "./cryptest.exe", "v"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cryptopp/sha.h>
      #include <string>
      using namespace CryptoPP;
      using namespace std;

      int main()
      {
        byte digest[SHA::DIGESTSIZE];
        string data = "Hello World!";
        SHA().CalculateDigest(digest, (byte*) data.c_str(), data.length());
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lcryptopp", "-o", "test"
    system "./test"
  end
end
