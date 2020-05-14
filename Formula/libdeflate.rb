class Libdeflate < Formula
  desc "Heavily optimized DEFLATE/zlib/gzip compression and decompression"
  homepage "https://github.com/ebiggers/libdeflate"
  url "https://github.com/ebiggers/libdeflate/archive/v1.6.tar.gz"
  sha256 "60748f3f7b22dae846bc489b22a4f1b75eab052bf403dd8e16c8279f16f5171e"

  bottle do
    cellar :any
    sha256 "d953614355c76a7aa75c6517fc60b4e5d4163fb5582690a3b00a3b9e1a4fd712" => :catalina
    sha256 "99672ee99b6bc41349c08cf4f047f21f780ad9aa9cf9eb7cca0639da4f79bb48" => :mojave
    sha256 "249ed4a8ee9ba404dd8cce6efff0365158992aecaab4a2923b9b62ad35f1234a" => :high_sierra
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
