class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gz"
  sha256 "60748f3f7b22dae846bc489b22a4f1b75eab052bf403dd8e16c8279f16f5171e"
  license "MIT"

  bottle do
    cellar :any
    sha256 "212aed6ec63f047e554de8f3214d7af20bff375032c8702df6f8964a568b072a" => :catalina
    sha256 "6ac658a25367a45ad9d5a28a98e0f4fd80fd8a40fba01b2655a177a0b6ceafbc" => :mojave
    sha256 "e61e6da245814b3964750d5db14567c85ed51421ea36e43aeee81906fd04a4d3" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/libdeflate-gzip", "foo"
    system "#{bin}/libdeflate-gunzip", "-d", "foo.gz"
    assert_equal "test", shell_output("cat foo")
  end
end
