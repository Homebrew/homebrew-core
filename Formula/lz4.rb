class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "http://www.lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.1.tar.gz"
  sha256 "fc2de900b63cc6e708d5d79a1d961fbc23e13a0a16ad230f27533d637eb7b349"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "f2fb292bafe98e31654fc85c7a032529c12a4d2139cf96d1211411106618a025" => :high_sierra
    sha256 "1168e44a252b92853ce8fe24976c0198bc2a252678d36c4d5fd999e6e95bc417" => :sierra
    sha256 "42f1aa22230648e0fe1dc738d6cf6649b35a9f5b5255322418de601347c7848c" => :el_capitan
    sha256 "5abd84100b170b6b8650f46639edb181fefda11ffd582c46dcdc72580ac1913b" => :yosemite
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
