class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.13.5.tar.gz"
  sha256 "46a19409d7f344438554d608f2f84784a31d34588bc93153b31d9cee61dd689f"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "682b35d970f4a8c4f42da9d6a8572b906aa979c04518d928d9a96e79f1eb0ee6" => :high_sierra
    sha256 "17db56d0fcd621a07ff5f76631f06a6618e0b3e0078b877ac85a8c169fffcd33" => :sierra
    sha256 "e1d8c1f4b5dd8332738b96a8c68c53ac5c150f93af0ee158b25d06970e68ad80" => :el_capitan
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
