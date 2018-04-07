class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.17.tar.gz"
  sha256 "35b7c08d55499446d4cc48d0ff8b523406ffa7f7b0e9b5a31f8585c00b454257"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "bb11829682c5135708301fdb485d99e9744a74a154d30efa0da2773f6275d602" => :high_sierra
    sha256 "4416c6776aa5288dfcecf76ba8960aa0dbf1b82bdce09db792b6da92b2254a95" => :sierra
    sha256 "35e80b5a933635a3cf1409efb3953a03ce86208294c7658bc675bb9f11880d59" => :el_capitan
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
