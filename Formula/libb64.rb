class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.1.zip"
  sha256 "20106f0ba95cfd9c35a13c71206643e3fb3e46512df3e2efb2fdbf87116314b2"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b96a38185041985c80316cb592fb20b2c3b24d982042441d0008efcc2ab1998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d58f54a9441400aa4558ea15ced076cc3d712fbdc2801b786b923b7db2220a"
    sha256 cellar: :any_skip_relocation, monterey:       "f21ec5a85fec4960280537fa0fad9fce59dd7544141a87576098e76b9c020e9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "155001ff9b7e697215db86e40e861308d601c7077c6ec10ef99acf007558415c"
    sha256 cellar: :any_skip_relocation, catalina:       "f2bdf6ee59f94515b24aaf0a2feb4fdce2b93910b9a802973434d2c7e769bc42"
    sha256 cellar: :any_skip_relocation, mojave:         "6b4f2d282b1ed8e03c4f86a937bcdbf3c8f79679a88568462133440f06d349e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9686789b247dceb95c23ebaa41b61f2d87970e50bec70c99b413ebadd8772d1a"
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
