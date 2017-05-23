class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.6.tar.gz"
  sha256 "039ea94effdc0b7392c7c7e1c131553164fcd9e7eb1d3ca9ae4970264a756330"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "ede0016ccf87a44ddc6428857a202cb1eefceeb17e94944d1590e4629b65d993" => :sierra
    sha256 "cd1486ce40744c9f3fd5e83ed0cbabafc83b63e6b0075366165b28e201e4b2ff" => :el_capitan
    sha256 "2cafe569d3d6ceeb7ba79d480af53497489bbf5afebca00477e3036012020725" => :yosemite
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
