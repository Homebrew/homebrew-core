class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.13.tar.gz"
  sha256 "892b97ab275b0bf003dc243c5ef2b668225965535be9b832e4ae5d41b4e26763"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "ecadfd78f4c67f3632dacea8d571c05b6448baf94fec01741ab4cbc947f768d2" => :sierra
    sha256 "e2adc4ea1c97ea966875487a4646e83162d01b4e4d3d742c3cc4b821cd1e4422" => :el_capitan
    sha256 "87b15f34c9eb4efd1d3e491bf0e52c2c0b8e9637f7fbff0297d583effd9e1276" => :yosemite
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
