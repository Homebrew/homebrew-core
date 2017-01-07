class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "http://www.lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.7.5.tar.gz"
  sha256 "0190cacd63022ccb86f44fa5041dc6c3804407ad61550ca21c382827319e7e7e"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "61eb4c99534b83a6ebfebccb86e654f420f8ef5efca6a67b3eb7bafda8fa8925" => :sierra
    sha256 "cc8e425ec43dc5dd3132af0d9138f75510c2e15c612dff8d6276f8e701e44c66" => :el_capitan
    sha256 "246808b1662baa862812fb15923f997e40329bcb0c0ebd4595af5eb90d9c5ff9" => :yosemite
    sha256 "c38d6b8d0d0c65580e422b3baa3f19cb051e9c02f05ee02ea1fbb5721959a764" => :mavericks
    sha256 "549d8bdae519e3315ecfab95ffd3a657d6991f72571c9720dc7d976d7445bd24" => :mountain_lion
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
