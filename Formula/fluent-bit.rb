class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.3.9.tar.gz"
  sha256 "95dff0e536c6bdca0ae339f0570dccbb1094719446454aad81d906d335f111ec"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "8dc7cc6f4ea7f040fc03263203311c81fb70bfd84a6c48c74014fcba0cf99e09" => :catalina
    sha256 "10575536d5160aa640e23012a0e6c530fd3aedf1fc815f57eefe8c937f2e7b20" => :mojave
    sha256 "1c94f930d468ce3727d1331697bda2b5660b323abdbf1e6cc1eab79e7ae69b95" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
