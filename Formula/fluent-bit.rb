class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v0.11.2.tar.gz"
  sha256 "11fa804ecba9838bc1e6ef2e7d5f3b7c4eec93ee55ac2ffb20b89dbf4aa5fa9e"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "e5771074ddea1ef22876ee2afe866f5fb839bb933407288fb8413ba750421d2e" => :sierra
    sha256 "1bf82122aea5bf951f7dfe9148f7b9f27bf1b4d58cf65e929bdb394ffe4d4de7" => :el_capitan
    sha256 "ef257b65bbac9813b3efd02250a80e2da4b47d2e2809e52b728187b73e29504e" => :yosemite
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
