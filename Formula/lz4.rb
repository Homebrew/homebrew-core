class Lz4 < Formula
  desc "Extremely Fast Compression algorithm"
  homepage "http://www.lz4.org/"
  url "https://github.com/lz4/lz4/archive/v1.8.1.2.tar.gz"
  sha256 "12f3a9e776a923275b2dc78ae138b4967ad6280863b77ff733028ce89b8123f9"
  head "https://github.com/lz4/lz4.git"

  bottle do
    cellar :any
    sha256 "472dea7a05a86e60471ec27ffe7093fba8144aa0e739fedcdb48149467c16573" => :high_sierra
    sha256 "63aa9e636110cfc2c192613458a84caa7cfab3f5a5056f8bb5805761e6fb548d" => :sierra
    sha256 "dab46e035b3c580c4ab4bcb1b546b1d2ea8dbea1c5e2788532a2fbd84b930dcd" => :el_capitan
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
