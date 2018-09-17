class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.3.tar.gz"
  sha256 "33af5936ac06536805f9745e0b6d61da606a1f8b4cc5c04dd3cbaca3b9b4fc43"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "8c6ce48bb52fb87c41f7e046c3bfc49f1cafce3900bca09d28647f9aa2d7fafa" => :mojave
    sha256 "482b331f6cff1d008d0af6f9e58620ab28286d0bfab4237ddab40e8c2df1d2b4" => :high_sierra
    sha256 "bc702825ea1970c9ff8dabf1128fbcc7900a5d3719455175b777b8d5119b287e" => :sierra
    sha256 "bc8d157d93aabed915fe3c57c5506f0438f9c0c9d1adeedd470875cacd4b5c39" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    input = "testing compression and decompression"
    input_file = testpath/"in"
    input_file.write input
    output_file = testpath/"out"
    system "sh", "-c", "cat #{input_file} | #{bin}/lz4 | #{bin}/lz4 -d > #{output_file}"
    assert_equal output_file.read, input
  end
end
