class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.15.tar.gz"
  sha256 "d6bf4fe30f877fae3a627bfc53e4c2c7f50e44ce992a9d72ca58040a4f4e1f8d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "8b257feac620d2d4f72b5725819be525b7abc742a35ccc006390429fcbb1a500" => :high_sierra
    sha256 "9da5342fcfbfa29e31004efd7b873960124f67e4386ebc47e81f222ff79ba794" => :sierra
    sha256 "739e9338f2d489b8d8b31a2937f810662e83fe5109a630ac4bd71fbaf30ab702" => :el_capitan
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
