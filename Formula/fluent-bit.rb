class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.11.tar.gz"
  sha256 "6fc29dadfba240a6bf1d201753ba71861113480d344a9b78728d680c1f7bbc86"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "afa9beae12cd485c76cb6da96c02fbc8a10de89b256f061c3d0479caba7c4b58" => :high_sierra
    sha256 "1559c972b7dc136dd73054e434224e274dc93afc28fdb5712f482bd4ebf0f892" => :sierra
    sha256 "2920c0d7d8540ff1964387199d3ce652850129d13df7efda344dbc81a8fb741b" => :el_capitan
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
