class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.4.tar.gz"
  sha256 "52df2954eeea8ac0e4e6c447c36c17ffd9a9b32f0630e5edfb7ab072315a90b3"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "c42b066528fedc4c0cd9cc3c45956d1e315674ee74e8c4029017d6a8b343a2da" => :high_sierra
    sha256 "eb2e2ae3a1b108e3967588916235b4acb55d3aa2e14b0c76d4deac9e6aee55a5" => :sierra
    sha256 "84ba0187c6382e58127431979cc4be08bcdba1009cf98f65e4d8911d99617dfd" => :el_capitan
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
