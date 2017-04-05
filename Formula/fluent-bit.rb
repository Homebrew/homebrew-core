class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.1.tar.gz"
  sha256 "920d29cb4b506a8dd98c9bbdcec32e87c2b9358b8ff447556492b55b025af785"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "781cdb42287c221a508360b7f05e0b17b6536c3e1db0f10fc495013a0850f6f9" => :sierra
    sha256 "16c9166eb43c09f17cb6b3b0052538923e60025fdfd4dba750e7bb90934e8b25" => :el_capitan
    sha256 "35106dc9d1ce186bb222ace3625bc3fde6f252e914637d94e5dcea613ba8c1bd" => :yosemite
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
