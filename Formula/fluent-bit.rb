class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.4.tar.gz"
  sha256 "daeee4cf5ab7e9722f3072aa5e0de7340d1ba4fd4be413ec6d5eac210104e053"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "4e4d5723c3836d26281627eca0bacf90eb4d6284584ae0238be3eb7d9e61aa23" => :el_capitan
    sha256 "47096bd201f82eeb166676629f839ca0f8aaeace800cc628a55d462dd7dbb006" => :yosemite
    sha256 "ef8492e3ba570b4dba31192b2fd0eba26d3703d0950f1c980a36a38f666053f2" => :mavericks
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
