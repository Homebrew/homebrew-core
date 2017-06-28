class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.11.tar.gz"
  sha256 "75ad6f077dc422ee8c3cb9c3aa0e808d5aab6152daeec72c78b4b09cd5630888"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "196a0f71a04cef739abb5ff16bde437d20e2d1f871706221789cce06008ad595" => :sierra
    sha256 "e43ec8609a975a4fb607d46bd5fd5ad9b266705c47903d3ae2dcb97b297b8434" => :el_capitan
    sha256 "adbf00ecf8563b915ca04753a0e79fa3ab8f4b107dd591ea5fb4e3f7f2e128b8" => :yosemite
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
