class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.10.tar.gz"
  sha256 "b3f878bc0bed5ba6cf463f7ea3613faab16857e72f695ba7a7c1556c569a76ea"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "69491102a54eb57e8c96faf1f7bd57b4d71d911d92d83b633813b7e93fb56bff" => :sierra
    sha256 "3e1202ff568690f29942f8c485a8361e561c3cc5cb85057e21342068319c236d" => :el_capitan
    sha256 "2edea15d73cada6bcb07507bd5f2cdafb26e7aea43e903da032358a9edbca6f2" => :yosemite
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
