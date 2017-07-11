class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.13.tar.gz"
  sha256 "892b97ab275b0bf003dc243c5ef2b668225965535be9b832e4ae5d41b4e26763"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "eee095e1d5b0f3d6bd2c6e56c03f7e6e8ab190b7642ee3003df60fa8187f3c53" => :sierra
    sha256 "67e896bfc82e3cf16e98ba9cde63488c825aec57f37dc59b95b29a8199b4bb07" => :el_capitan
    sha256 "8eacad04b6d433d6c0eb199b292f1b7e9d2edd9acfadfd05a3b1efc1d9932745" => :yosemite
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
