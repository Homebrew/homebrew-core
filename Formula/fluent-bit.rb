class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.14.tar.gz"
  sha256 "a36cd6c2975cb44fe1d7b43ccd3bda391dbf2880c69b4b383f3006fb9cdad5a8"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "90e8130e163dc744145dfebd10aea3c2012325732939bb00c9ac55fd52d0d185" => :high_sierra
    sha256 "98432c82e54e5eb0d2d77875d19fecbe15ccb8d86db4e083f52ac109d6ff0cf4" => :sierra
    sha256 "7792cd2fa43aa31e587896bbcf87bd110fb5c9254c138b4dff2a93c2483273f5" => :el_capitan
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
