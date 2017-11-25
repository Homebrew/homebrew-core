class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.9.tar.gz"
  sha256 "e2bf42afb62347ad2c43ba6aa9a2f27d27a2adf4dd9b8679df057f6514f9e22d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "2165f951ff381dc7cd29f27f6e48c4c7f348a5eae9ca5c35c0b79ca66fe58e1a" => :high_sierra
    sha256 "435fd53881655d45cbc3f153f9c7b0f7d38ef590929d291c26ed16e220783285" => :sierra
    sha256 "7f41bfbcd5de3db0c224e93538739752220075455abc78c40f7b262c9ede0d4a" => :el_capitan
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
