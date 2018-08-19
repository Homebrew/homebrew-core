class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.8.tar.gz"
  sha256 "0c3235974d003b4e6979f7944bdc01df46eb8672ceef89dc537ca3e23742b765"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5f0d22d71f036cff55449e0d4184c170f242e767cdcab057059c5d5abef94348" => :high_sierra
    sha256 "0137ff058a98542ef6f0f8bc720dc9bb47581bf710acb8823a7ff901d6b50898" => :sierra
    sha256 "406b7027ca2b9e9fcdf12e0790c12aab4f3f55414f045c3b03ebad6651dd5d6a" => :el_capitan
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
