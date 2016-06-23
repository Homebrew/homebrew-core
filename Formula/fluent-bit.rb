class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.2.tar.gz"
  sha256 "fb5c9bd23a97ae83a93ec76f4ab92a7710b952c68595eeb78c1770372c8550c0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "11f0500eb4a79c532bdeed3d9f2ecd48430f1ed9927e8abb532c9e0d32e50f80" => :el_capitan
    sha256 "8433a84e1d47dcb13fa95dda6a830586ade607900a2d3bccbebf8d635745f581" => :yosemite
    sha256 "1c71aa568c89e781d46eec19db0836c74fb596cbb9e3aa303fe0f8d44b524014" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    io = IO.popen("#{bin}/fluent-bit --input stdin --output stdout --daemon")
    sleep 1
    Process.kill("SIGINT", io.pid)
    Process.wait(io.pid)
    assert_match(/Fluent-Bit v#{version}/, io.read)
  end
end
