class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.9.0.tar.gz"
  sha256 "fb2f84e71b248346a85b737d18d2146891847f1059ec65f2b3619c5f99040986"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "e0c76b46e0663855d1731f356f2bdf3e7dfcaabc16941037be8b996e26737935" => :sierra
    sha256 "42696fc2a4a0bb29cf1715329b25190881c9a713f3c37c48136fe722a128d4f4" => :el_capitan
    sha256 "a3826526e4d762edbe7a2d3411923dd70c3cb38c82737f8c55a68f64500046f6" => :yosemite
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
