class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.11.tar.gz"
  sha256 "75ad6f077dc422ee8c3cb9c3aa0e808d5aab6152daeec72c78b4b09cd5630888"
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
