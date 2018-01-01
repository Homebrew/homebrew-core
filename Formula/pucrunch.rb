class Pucrunch < Formula
  desc "Hybrid LZ77 and RLE compressor"
  homepage "http://a1bert.kapsi.fi/Dev/pucrunch/"
  url "http://urchlay.naptime.net/~urchlay/src/pucrunch-20081122.tar.xz"
  version "1.14"
  sha256 "3488bfad58e2fac8f6c429c8727336dff7840d3c1dbf3131afd5380d77996d25"

  def install
    system "make"
    bin.install "pucrunch"
  end

  test do
    code = [0x00, 0xc0, 0x4c, 0xe2, 0xfc]
    File.open(testpath/"a.prg", "wb") do |output|
      output.write [code.join].pack("H*")
    end

    system "#{bin}/pucrunch", "-c64", "a.prg", "b.prg"
  end
end
