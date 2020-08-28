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
    sha256 "ee788cea9a073c456398f86661ea27e092c3d327ea8b0792643ed7d38bd402d0" => :catalina
    sha256 "7a53661bc0fe2bea875f0a14cc66b6352694f1e797e4506ad2c8ef35dfcc2169" => :mojave
    sha256 "3b5266e99b78c81ae7ec00c19aa7e9d3fad7f47611fc1332710bd8e03f48da55" => :high_sierra
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
    system ENV.cc, "test.c", "-L/usr/local/lib", "-lb64", "-o", "test"
    system "./test"
  end
end
