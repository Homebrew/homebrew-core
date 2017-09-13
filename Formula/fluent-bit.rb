class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.1.tar.gz"
  sha256 "aa007a2131799c85d7b4f6ab0cd9c85a6f14fd491c1fcdc998fe4ce25ce55048"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "c82ea16d402f9da0646cf9df3986c62ea3af9159cda601fb6cf8845f2ef1371a" => :sierra
    sha256 "4f6d8221bd476790fe5a2c9221f97f88dc88c7b4adc4a8828e6272b7a49be1df" => :el_capitan
    sha256 "2906b7d3bcd0cda582e4596f7904f974e634157bb24158af9b994206689b885a" => :yosemite
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
