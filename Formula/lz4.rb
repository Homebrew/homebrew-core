class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "https://lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.2.tar.gz"
  sha256 "0963fbe9ee90acd1d15e9f09e826eaaf8ea0312e854803caf2db0a6dd40f4464"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "6988838206bd7f5858f4d74052febbbc64258845f4c7e1a818b6991c12e64e7f" => :high_sierra
    sha256 "140eb0d0a74342a2509b804de3bd2e89a59309a83fe74bea5013aac7cdfc3bc3" => :sierra
    sha256 "86baf3b3e20b927e8d5667a5b6cb59f3145ef1ddcb0f5e056962390a06fbd162" => :el_capitan
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
