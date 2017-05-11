class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.5.tar.gz"
  sha256 "947849f933500c8847a3d7671a98be1a9e43159717c6da79120e31c2da0f0e6d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "7614b4df64cf2902a2efeb2f206665da3f2ffd274f0be1ebef4e66747d978c01" => :sierra
    sha256 "847f45e36e7e23ebf63976ace96721b2fa61a15532b0f7d713f6a6f74b55e98c" => :el_capitan
    sha256 "fe2d850a5699444e69297c72d13bb26e5139e37b51e37a4cc6a2d4bd81c5c0e6" => :yosemite
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
