class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.18.tar.gz"
  sha256 "9efb4d9cc51d293c69286a271311912caea0a072c72b79982229b2945e04d1a7"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "89dba3bd164e96f5bb971dfdd61e7d79fb782d31463515e1de9583f381fd16d9" => :high_sierra
    sha256 "fb8e6eeaa23ebc51856fffb0c6bb92073d7858c86c37536a328083508c775334" => :sierra
    sha256 "db5ef969afa4fcdb1fd9de21293d6411ceff551be02f827b06fd26a38ee5b88b" => :el_capitan
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
