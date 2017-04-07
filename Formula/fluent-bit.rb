class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.2.tar.gz"
  sha256 "11fa804ecba9838bc1e6ef2e7d5f3b7c4eec93ee55ac2ffb20b89dbf4aa5fa9e"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "d40cb655984870123b2282021d7270ebaaceda46d0989b081826213d1f87418d" => :sierra
    sha256 "413be12bf1d4677ebde56148b3a7450314a77426a8bf05f98e073f09096dea38" => :el_capitan
    sha256 "72fd0c7dad2a0014e50ea4113121492ee423ffa9e123d33c2ecfb81374f9b965" => :yosemite
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
