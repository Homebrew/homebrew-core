class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.9.tar.gz"
  sha256 "56f7f5932fec98409ade22b1ecde19ee1c910095e9f5ac8a4c27bbe292656331"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "28a6549b884689563b9115c1e0d60541b0ca2e8d2bf352fc71bb5cc2801ec249" => :sierra
    sha256 "ee4d4732b871d9b760d8e10e5100701e6b499ca354aac01cbaeeeff96b9eb725" => :el_capitan
    sha256 "3c1f1a44ef74ac1e778574946a26ed7e629bdf9aa8dfcf3c64ea9a8af6122a9f" => :yosemite
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
