class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.9.2.tar.gz"
  sha256 "658ba6191fa44c92280d4aa2c271b0f4fbc0e34d249578dd05e50e76d0e5efcc"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "a898c71e6e254a98310ed55d54962685c2c08c181dee12ad5f705083e18c168d" => :mojave
    sha256 "a3e6eac647b6a34547606523e97d004f29cdf3866334d04238bf088340e29a14" => :high_sierra
    sha256 "5174837050d5f09eed1cff0b9afa224e02964f7e93f1309ac99cbf67dc1b2711" => :sierra
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
