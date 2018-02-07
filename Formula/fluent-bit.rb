class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.12.12.tar.gz"
  sha256 "3fe945d3202ed582bef1f5d6f37c68f52addd7e5291634708ba930be0cdfc29a"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "c6edd073ab5b50ba563a3e96f5ae194f7f036af598fcdbf5cd6ba4d418343354" => :high_sierra
    sha256 "9193a0aee2cbf4f3cf5f92b92ded29d9f270f7145f14e924aaa522216c6edd96" => :sierra
    sha256 "da9f9f2b9669ec083cd7786c06391209ea1a1840b26d7f8097cc129d6cd43532" => :el_capitan
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
