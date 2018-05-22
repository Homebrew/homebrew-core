class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.2.tar.gz"
  sha256 "c9527fe0c23b4f75a847fcf21a9bad807b6f0d21066601522898689d9ac60ad3"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5b743d56a9a6a3df4f1461b1fdb4a5997f50d278b64a3b98aeb04d2a0ac30a0f" => :high_sierra
    sha256 "452ce8c3b14d4414dc0ad8a3d8844d2a0c59a009d336cecb866d4e5f81f9719d" => :sierra
    sha256 "0b0ed17b101666bf3dfc66e1d3930b86968b4e10d21948f2e69681ca28f19c3d" => :el_capitan
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
