class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.6.tar.gz"
  sha256 "a002176753eda14707aa0ac67327e5074bd8e187cfec9e67365f5cbdbbe9b9f2"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "31c267e13b20c526f2eff153ca7e8c757ab77fe3a5aa0ab088b6bf78fbb1f3ab" => :high_sierra
    sha256 "5679b5b864329094ee64a7284c383bb2f8356512759aa96cc47a3a9346af4316" => :sierra
    sha256 "2e0003bf599de0d561db78b1ae943074cd9a094ee012c26790d1868faa465e64" => :el_capitan
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
