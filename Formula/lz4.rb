class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "http://www.lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.7.5.tar.gz"
  sha256 "0190cacd63022ccb86f44fa5041dc6c3804407ad61550ca21c382827319e7e7e"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "88b2529f3abbe23e0f8421811a9621435bc7f817819385e947d4519964b38585" => :sierra
    sha256 "0980c7ab151e31e7b16f2bfb8a9d54ebbdcb99327d9906190d624eca4dbe47ab" => :el_capitan
    sha256 "de3dfd98edc6c0613c4842b1121551535a3672ab4737128ea2e7a6f73e188b9e" => :yosemite
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
