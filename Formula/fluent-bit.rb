class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.1.tar.gz"
  sha256 "dcfe96e3aab03edd23b933b0df04606a816fee86260a6532b17109f8ac42fa88"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "264c7f95dadd7cfd9ec6b6ca56280bec684c13b4900d1ac4262f31f2cdee6f71" => :high_sierra
    sha256 "7490224c45bf5507e439d609dcf1180692519b54054b8b09a3142d8dce0c86ad" => :sierra
    sha256 "38c32b3c477a7d152a4a412555b29551042be3f90db570cc7f074f51d5af1f04" => :el_capitan
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
