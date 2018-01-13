class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "http://www.lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.1.tar.gz"
  sha256 "fc2de900b63cc6e708d5d79a1d961fbc23e13a0a16ad230f27533d637eb7b349"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "18fce11b03002004968347a5e1068918bf8efd3f2f73e8ff8f49e0ccee2e0b14" => :high_sierra
    sha256 "60ac08cee152ca6ef3c470f1c5434566faae0ea1ed91d0d411610ccf70221499" => :sierra
    sha256 "089fb3dc78b935fb36f04ff8afb4d4147cfc34f1e6639bc5d6d9ecae117f42c9" => :el_capitan
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
