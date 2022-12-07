class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.1.zip"
  sha256 "20106f0ba95cfd9c35a13c71206643e3fb3e46512df3e2efb2fdbf87116314b2"
  license "CC-PDDC"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "899db1753787af2de66e4ac321d5d750190a8357576611d59644eaa9ed0f852f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf8f611b34a951b0c3930f8c3714e0f24aa4074c79a3cb483810b7325461f1df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acd1c54a87e5e659d5a2d907f650cd9a3d1f160403805d8d84f7bc620546df0b"
    sha256 cellar: :any_skip_relocation, ventura:        "2c8d53e819863560658ef3a9ec30d5472430d00b93cb165d12f4e2c12eef12c6"
    sha256 cellar: :any_skip_relocation, monterey:       "3b2acebf1e9432ef07e0035bfc410fdb8530aace59513ad9fad36fe35a661880"
    sha256 cellar: :any_skip_relocation, big_sur:        "50dafb7c970bfd56ab7c88100df7876d1590c806295987a8268029eb87b7ca2b"
    sha256 cellar: :any_skip_relocation, catalina:       "4f357626774a02fae97f7668665a8e41c96b4cdf041a8b8ba658dbd5f8a86bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da3dbc95cbf4c396038b3b71fbb2b6b583f72f46277cb6deea7b7afb410e9f7"
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
