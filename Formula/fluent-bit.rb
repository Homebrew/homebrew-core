class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.2.tar.gz"
  sha256 "335e296e99eb439ae830abe4e1f04af1b5bca4dad69f53ea1f9e99c8b1002bf1"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "0b2d90b5d2c308361bc7f89d06d1b3e90d75b3302840801d3cf705165c7f1c80" => :high_sierra
    sha256 "43df6994f2df13c165f9a503600129af1a626dcf50017bfcf4a46ff7f6d8e0ea" => :sierra
    sha256 "1cb09af26284ad26ac43a4c47df4d4cfa5758aca5846f5878e1c7a4f2bfe52e3" => :el_capitan
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
