class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.0.tar.gz"
  sha256 "5f38139939cbc8cbd0f2b4d063d5075977bb53e51b8f956acc2b27bded8f686d"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "4140e89367dee5fc0e4556c0a1bcd40b28cceeeeb057b7b90adc290eb77c80ab" => :sierra
    sha256 "df59739709f871645033e0fae98b3b666b800e27f270cb27c765d145ea233f4b" => :el_capitan
    sha256 "32f8b95a7a3019930f0e1c135241ee5afe25de6a0688991aaa745172f1a2f44f" => :yosemite
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
