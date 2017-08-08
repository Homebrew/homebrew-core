class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.16.tar.gz"
  sha256 "2be25f002a6887cd51e65f89e6d635fe846f9c28a88670c31d1a77995cfead67"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "9f605c8b7be41419a01590b598644fb85baff2daab53ebd67a2da374f77b0ad4" => :sierra
    sha256 "c78a2c37e2e77b8fdc28df5137c47e8d575847b767df6d3681e0e88be367ffd4" => :el_capitan
    sha256 "5ff7097fa46e8a6b9dd77cf7c3bbb9eb94dc6a34560fa1da7fe5a38930c3c822" => :yosemite
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
