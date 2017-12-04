class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.10.tar.gz"
  sha256 "cc73ccef5ea04e43730a13ed71b56a98bbab62989be675a4cc6285728b523493"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "090b8a337ac3afcabb0b94b641a8072749ca0d7f42abed4044152a7fedc6f5ef" => :high_sierra
    sha256 "614eef0ef06dd2c474087b12936a094e79f3638855db6732966b125b17ebef96" => :sierra
    sha256 "6320f1606e0e0ca7de9e6877e91553006c912b18807821d3f72a5621f54e566a" => :el_capitan
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
