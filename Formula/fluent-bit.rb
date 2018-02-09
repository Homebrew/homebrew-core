class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.13.tar.gz"
  sha256 "45089e3377a689eb3608e2f7a019eff3c1f4099bbe8abe4a1ff23ebdcc7397ae"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "b7d7e5d446bd9960e1415d8c4d36dc3a6fe15bc0186d4475d985a4d5a97d6e67" => :high_sierra
    sha256 "2df6dc08a40ab64e20c7ef907d127801d7b47d683cfc19488f04220e4eb91bc2" => :sierra
    sha256 "91728b3c05f48ebe9f6f3c4c2721672ebb4c8c99e24f7215864a635901cef472" => :el_capitan
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
