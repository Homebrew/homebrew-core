class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.15.tar.gz"
  sha256 "5bbab21cb04b4d366e2e83fb10e33161c6a3bd409728cc2bcca8fb5c0796460a"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "fffd378d1c4004034045603826e73e864c01d4377bd9aa2d4e5d5b9c5310ac66" => :sierra
    sha256 "6e162239c9be3d986aaeb120b76374f3d89e71db5ba2cdd9b304a0f7434b6f81" => :el_capitan
    sha256 "23b3307ab2c590749f996f064d7743ce3a4c53fbd6435677d29a75094d4f9af5" => :yosemite
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
