class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.17.tar.gz"
  sha256 "35b7c08d55499446d4cc48d0ff8b523406ffa7f7b0e9b5a31f8585c00b454257"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "b116b75226c5d1e84eaf6f4db01b8293bae65c3f427e17574f4799a995e3c095" => :high_sierra
    sha256 "6d53b98a61a0a3d846e55a5570cf7aa6107938c077b87369db00e86c0afe280e" => :sierra
    sha256 "ee26501e7a1e8508c583cf07c83bf28b35b338e6f31d8d32eaef8b40a5bdd19e" => :el_capitan
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
