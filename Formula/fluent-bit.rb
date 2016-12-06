class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.9.1.tar.gz"
  sha256 "245034d90724167bbc295019a638cb68393fbe0ab1c789574067dc4be36d583a"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "a3b42b0da6eda101737cd3e2df4413297b3f92236e49614012a4ac45f8903d96" => :sierra
    sha256 "99067e3794dffbd77cf80cbe981371cd53ff9ba8ce4eb14b404c4fcd5fa208cf" => :el_capitan
    sha256 "342e3e0363f6d7ea22efaab08eac264072a7105537c59fb2a8291594ebbae51b" => :yosemite
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
