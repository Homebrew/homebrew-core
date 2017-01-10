class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.10.1.tar.gz"
  sha256 "78349c453c0546025ef38f7912f20f63f6d152c33ff36e77892afa2253b9ce48"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "012216b035e64fbba9aa81cfeea414e6acd2e5e49825376f6db31c502910e31f" => :sierra
    sha256 "1595b57e2e7cc9e8e8bc8e03ddc77c6a6fab5bcb957e6b4ccea6e1dfc404d859" => :el_capitan
    sha256 "5abd7dc368dc68848e0a31960f7e9b23f064c3e97f39ef125cd4af381fab99ee" => :yosemite
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
