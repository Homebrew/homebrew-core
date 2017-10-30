class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.6.tar.gz"
  sha256 "514c21bdca29b9006c71329e08b87e700a9e3c8bc9580b3ae7c93b3504815c56"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "a8bc27bf525185d38fceb96d9b46b171dad93c6f88f16c7afab9c1817eb45637" => :high_sierra
    sha256 "cf1274ecaa19161e8a899bb0f49e76f945da3123f5bba3ffd361d113fbf4dd98" => :sierra
    sha256 "8abad7e87d9c7288955c8563964bc97282640a3b9c6aebeb862d3fafea44d4fd" => :el_capitan
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
