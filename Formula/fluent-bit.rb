class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.4.tar.gz"
  sha256 "daeee4cf5ab7e9722f3072aa5e0de7340d1ba4fd4be413ec6d5eac210104e053"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "b4d40dd425a8a4778f381598eb48d6021b6cdeb29c80d7deb7ec9de53ec9d3ff" => :el_capitan
    sha256 "78056fc792485ff3c01ed76f521c003d7968ec1a4bd55cb4206af9f2301cb9c8" => :yosemite
    sha256 "e77152a0b168916b89c146486b18a625433a183b2a6ac7b9a73f4b221f8bcb52" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."

  def install
    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
