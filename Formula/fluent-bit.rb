class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.3.tar.gz"
  sha256 "4a04b719c0ae623e115277a954f7e86d4d5c43739b42dcd3df2cc5e93a0dfa32"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5960f09fe24001ef263faf75b3a6f18761a93f5869f034d6d6d2bdc675c58eb2" => :sierra
    sha256 "91abd1cad200fa742f9f9c1ce22af33fa817900b8e7aa8450b2f5de50dea6603" => :el_capitan
    sha256 "9e39b71282612526b5136b9cf54213785d84dac894537bd54135e9f882c1ad65" => :yosemite
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
