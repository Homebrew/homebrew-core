class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.10.tar.gz"
  sha256 "cc73ccef5ea04e43730a13ed71b56a98bbab62989be675a4cc6285728b523493"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "817dec70da9f5926d1f0fa1a94afa15c6b35316e7c45f0eba41e98a57fa77ded" => :high_sierra
    sha256 "f8915b6586791ea2aec3001d34191a64200dc20f366ddc33afeefe17c7093d0c" => :sierra
    sha256 "cd7d6104ad4f738c34767545ff1a3cc05fa8fb48b73fb1e3a9d2aeddde4d4c31" => :el_capitan
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
