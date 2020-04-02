class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.2.tar.gz"
  sha256 "71764ce8b111975e4749864d57d04977cfc0ba9e6729be659392cf5b7c4aaafc"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "00069ee8461277c9ae99fb493d80138099175fb276b19ad107ccc5b12ad4b455" => :catalina
    sha256 "3f37913364d64ac98db6e7fbac6b65a963f2c187f4661097dec1700f8a0d5923" => :mojave
    sha256 "3c3c7abce10d681cd15f242da9b71b30dc41baa38f077c0fa6dbb454fc03db7c" => :high_sierra
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
