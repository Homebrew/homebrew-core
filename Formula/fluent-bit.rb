class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.3.tar.gz"
  sha256 "488f8dafdde0cab565c1abc3f337e1d7cd9cd3037bb0276e0ab9a0a7e0e617f4"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "328661375a39be19bcfffe50ad5f8ff0fc0e501aed14fe7e622104a44c79ac9c" => :sierra
    sha256 "5b351767f9cc776229f94b955ac321e0624017e23189296a12e5a6241ddeb673" => :el_capitan
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
