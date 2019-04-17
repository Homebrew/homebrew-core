class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.9.0.tar.gz"
  sha256 "f8b6d5662fa534bd61227d313535721ae41a68c9d84058b7b7d86e143572dcfb"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "0319b38bd566413a2ce58bf49e288411be1c5f38198018f8821d6117426b0c57" => :mojave
    sha256 "5413e031d46bc35f40d6ca17bee04cd382ad1549d4693a0e6a8fa701b346ccc2" => :high_sierra
    sha256 "575ebf1f65b8c9e28c4bd769ed0bfa4ee4f575d2e0cd40d60f2a2041d40b3f21" => :sierra
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
