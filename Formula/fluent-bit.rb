class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.3.2.tar.gz"
  sha256 "84bb434a5e641bd729c2a7a9fdc70f74be3d8f42d53bdb5066111250c49f08d6"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "731d9f7bad5b033f0359a637151c4bbcf9d22fba31fc15414b50439d4812d6c9" => :catalina
    sha256 "ec6e6e3259a0a0d6f25a0467798c8223b5e94231a04e70f0077c986f84615ade" => :mojave
    sha256 "5438f937737d5f73d88a4e794289e64adb3276f82662dc350c5a03f410338eaa" => :high_sierra
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
