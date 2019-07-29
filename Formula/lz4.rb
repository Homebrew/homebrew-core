class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.9.1.tar.gz"
  sha256 "f8377c89dad5c9f266edc0be9b73595296ecafd5bfa1000de148096c50052dc4"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "a898c71e6e254a98310ed55d54962685c2c08c181dee12ad5f705083e18c168d" => :mojave
    sha256 "a3e6eac647b6a34547606523e97d004f29cdf3866334d04238bf088340e29a14" => :high_sierra
    sha256 "5174837050d5f09eed1cff0b9afa224e02964f7e93f1309ac99cbf67dc1b2711" => :sierra
  end

  # Pull request submitted 24 Apr 2019 https://github.com/lz4/lz4/pull/694
  patch do
    url "https://github.com/lz4/lz4/pull/694.patch?full_index=1"
    sha256 "9a4a4a94fe27492fe9e90c4c656e6ba7a0476f509433aa559958292ee2147850"
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
