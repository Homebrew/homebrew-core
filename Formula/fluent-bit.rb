class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.5.tar.gz"
  sha256 "5ce6a8269402d1800e79671fe30bea38926c959cbdf0e87ae7939da61f23f35e"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "64031d4f5bfa57fe3e8a9e4c4cc657693ee59bb1938cd43c3b10b140240ebead" => :catalina
    sha256 "25c5ceaa2d7f2587128905c9c7e569912837dc26efc423ddfaf4fd7a2303c01e" => :mojave
    sha256 "4c87aca55847c43c373e30666a6a0e77e325c92708ef818540e47c83b3a961c4" => :high_sierra
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
