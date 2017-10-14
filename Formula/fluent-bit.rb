class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.6.tar.gz"
  sha256 "514c21bdca29b9006c71329e08b87e700a9e3c8bc9580b3ae7c93b3504815c56"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "359247da6498cea23493ea13068a9489916ebb3a85d665302ab438ccb8a5ab65" => :high_sierra
    sha256 "d1e833087a907070fe0c8bdb1c9dd5cceeda47cb5c169338233676fc24a94daf" => :sierra
    sha256 "cc22fc7c8241ef88476cca028f8271fc413d35ea62921ed30f7842b5de647c40" => :el_capitan
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
