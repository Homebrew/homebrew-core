class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.4.tar.gz"
  sha256 "f9abc86ca56fbfc7b5c3fff1511f21e6eaa4c75cae7690e2fcca381872abf6f7"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "bee04637d261542b20ced7239fcf19a936732a74c2b385f6ea7725a218f46f59" => :catalina
    sha256 "d6e6caf354fc799c79fa837d145c593cadac28a7de03e88714faa56ed33c71a4" => :mojave
    sha256 "b226652b284edb2045743125baa15db5077ed1949230c65db737e70984b24faf" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

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
