class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.8.5.tar.gz"
  sha256 "a028880ff4b80eb52137d43c72d2291af1b7ef6192f3ba922ae408f2e28b03c0"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "8147ff5c949478a670c0520a317325c09f626f07acacf8f3652ef948baa8ca33" => :sierra
    sha256 "686a68b6aac9d14aea6d39f96ae8fdb4cf37a099e948acc55634193e836e0930" => :el_capitan
    sha256 "ed1a751e17d5e90d6af02382cbe05b736afcdeebd9d120d7fbbb16b3ced33679" => :yosemite
    sha256 "e2cfd67ad579251f39e883356e06a2b56e316497d51478473d94771ee49bcc33" => :mavericks
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
