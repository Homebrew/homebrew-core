class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.14.tar.gz"
  sha256 "d43f2fc96872d7b9c8f14d47d75b03763a4800bec40062065b4a72ffee65c8e5"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "38d1d1accea4210deb1af1683c2504c2a0fb24a297b7fd61d4cd6dfd5fe97c16" => :sierra
    sha256 "be5c3dc43dba8f28742a2d18ed3b278f81afd282089f09033d97dea86264c4c9" => :el_capitan
    sha256 "dbc1a76c121b525bfc7732ded15fb1e7ea71b4e077b1b5e8faf3742354576487" => :yosemite
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
