class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.src.zip"
  sha256 "343d8d61c5cbe3d3407394f16a5390c06f8ff907bd8d614c16546310b689bfd3"

  def install
    system "make"
    include.mkpath
    include.install "include/b64"
    lib.mkpath
    lib.install "src/libb64.a"
  end

  test do
    (testpath/"test.c").write <<~EOS

      #include <b64/cencode.h>
      int main()
      {
        base64_encodestate B64STATE;
        base64_init_encodestate(&B64STATE);
        char buf[8];
        int c = base64_encode_block("\x01\x02\x03\x04", 4, buf, &B64STATE);
        c = base64_encode_blockend(buf, &B64STATE);
        return 0;
      }

    EOS
    args = %w[test.c -L/usr/local/lib -lb64 -o test]
    system ENV.cc, *args
    system "./test"
  end
end
