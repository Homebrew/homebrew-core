class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.3.tar.gz"
  sha256 "f44a859950d7ecb744794ae91f5088885949758bce6fb2e7ead2e369637f0933"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "2965963f1236484a65f0072358ceb28a22c5cb9a15f98a6b7fb9ba9812ccd870" => :el_capitan
    sha256 "bb26c83d954ff381595269c1e85927a9991d92e16d21d8c36a18be6ed8212bfe" => :yosemite
    sha256 "a20e7aeefe05b5c51720e24064d148c4a9d817e77b11a7691e6d965d87e35170" => :mavericks
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
