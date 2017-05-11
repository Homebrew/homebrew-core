class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.5.tar.gz"
  sha256 "947849f933500c8847a3d7671a98be1a9e43159717c6da79120e31c2da0f0e6d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "0c42e08b4a61196adae4d170539ae03f9aacf2405e5661d9db783e61b9dae3ec" => :sierra
    sha256 "c2bdc8415f554a85891eb2f3241b33e4b1cb3f382eb9a14c62a0c6e83b269433" => :el_capitan
    sha256 "6e0a5362abdfdf9985eca928abd5db456cb8cdc229e7c5e5c366b89a97266198" => :yosemite
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
