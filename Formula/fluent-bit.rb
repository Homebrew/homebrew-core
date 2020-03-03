class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.3.9.tar.gz"
  sha256 "95dff0e536c6bdca0ae339f0570dccbb1094719446454aad81d906d335f111ec"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "5c356f2ddb8ff51ff8492614e8e3530c413a4c85c6933f6d941908bf3413ac8f" => :catalina
    sha256 "2dd788e30d44563abf2b6afcf357895ea39dfcb79e5525d9d8b3fc4a1028e6ca" => :mojave
    sha256 "62f538e44e959d5bb613e5c90c7b2b897004cad6354f7ba7ea6fc6f87ca4e878" => :high_sierra
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
