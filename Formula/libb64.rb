class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.1.zip"
  sha256 "20106f0ba95cfd9c35a13c71206643e3fb3e46512df3e2efb2fdbf87116314b2"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "155001ff9b7e697215db86e40e861308d601c7077c6ec10ef99acf007558415c" => :big_sur
    sha256 "56d58f54a9441400aa4558ea15ced076cc3d712fbdc2801b786b923b7db2220a" => :arm64_big_sur
    sha256 "f2bdf6ee59f94515b24aaf0a2feb4fdce2b93910b9a802973434d2c7e769bc42" => :catalina
    sha256 "6b4f2d282b1ed8e03c4f86a937bcdbf3c8f79679a88568462133440f06d349e7" => :mojave
  end

  def install
    system "make", "all_src"
    include.install "include/b64"
    lib.install "src/libb64.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <b64/cencode.h>
      int main()
      {
        base64_encodestate B64STATE;
        base64_init_encodestate(&B64STATE);
        char buf[32];
        int c = base64_encode_block("\x01\x02\x03\x04", 4, buf, &B64STATE);
        c += base64_encode_blockend(buf+c, &B64STATE);
        if (memcmp(buf,"AQIDBA==",8)) return(-1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lb64", "-o", "test"
    system "./test"
  end
end
