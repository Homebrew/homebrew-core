class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.8.tar.gz"
  sha256 "04baace0658be48ff1c877113c090d9c18c0fb50b3d47ff0203bf7444336d855"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "d9b15ab58517e776f3a2d4db1490989bc0f7023b0ae4ff510bd90c41f4cba63a" => :high_sierra
    sha256 "aeca8ffedf93a30a91f2a91bbacd431c1e48e15ec16d3a784d60282d11d7256f" => :sierra
    sha256 "6c22fb7d535d08e4fbafff87295cd93eb8f333314028d4873ad10d1c51bde7c4" => :el_capitan
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
