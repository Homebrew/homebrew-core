class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.2.tar.gz"
  sha256 "c9527fe0c23b4f75a847fcf21a9bad807b6f0d21066601522898689d9ac60ad3"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "8f0de608f62118f5cdbd875a48871e11511ec2775e2ba8f7f86f1782d1cd0a93" => :high_sierra
    sha256 "73a9f8c313e1a13e473c066ca67b00f8e51ee494b636469997b99ee1d4a54af6" => :sierra
    sha256 "1fae021e6453b53296c5f54e4976a22cff40822b09e361a86c3adb549fd626de" => :el_capitan
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
