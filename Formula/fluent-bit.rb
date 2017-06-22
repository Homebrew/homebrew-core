class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.9.tar.gz"
  sha256 "56f7f5932fec98409ade22b1ecde19ee1c910095e9f5ac8a4c27bbe292656331"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "31d5880534f3c783e7954d1b8de162e8d19b341d2f6de5e64fddf1d5658a8598" => :sierra
    sha256 "8feeb7d3a266e08f4d58467cf54a23f2de2df3540766a254d71c713267415f77" => :el_capitan
    sha256 "36f156fec774f75d206262aefe1c8cf6fa196b45434186164281074163e15e6b" => :yosemite
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
