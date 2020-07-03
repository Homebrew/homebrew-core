class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.5.tar.gz"
  sha256 "5ce6a8269402d1800e79671fe30bea38926c959cbdf0e87ae7939da61f23f35e"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "a7e1c21fca506273c4c55803069f356767c3a761f88b4e6aad31af50f338852c" => :catalina
    sha256 "f1a7202594bce8b54583ad45972784d31fe6f076caa1dd3c14c74157def88198" => :mojave
    sha256 "e1ade0ab0cca8cf718836fb0d1cd72bfed7a669e493b41b488c09816eafcc20c" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries"
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries"

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
