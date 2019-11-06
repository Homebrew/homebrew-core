class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.9.2.tar.gz"
  sha256 "658ba6191fa44c92280d4aa2c271b0f4fbc0e34d249578dd05e50e76d0e5efcc"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "7de6165d86c7a7ae01d254a5d0ea0a6d5876f90cffb63a2570942d46cca6373a" => :catalina
    sha256 "67ca428e60e2c2f6e524dd3de42629c1a616d28b2c743b66bf4cbdcc3b28ea46" => :mojave
    sha256 "7f60879b81a3a9ee52b3e9b87ed265c4934058b841e8f5320044f826b4660a92" => :high_sierra
    sha256 "00d3610cf09b0fcde34928890f5dac870ebcaffacd6eb51eaea05b754753e462" => :sierra
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
